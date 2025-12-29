let
  key = name: {
    sopsFile = "/etc/secrets/users/${name}/ssh_pubkeys.sops";
    mode = "0644";
    format = "binary";
  };
in {
  flake.modules.nixos.secrets = {pkgs, ...}: {
    sops = {
      # Systemd in order to use systemd-credentials for the protected host key
      useSystemdActivation = true;
      # SSH host key is protected by systemd-credentials, this is the location it gets decrypted to
      age.sshKeyPaths = ["/run/credentials/sops-install-secrets.service/ssh_host_ed25519_key"];
      # Do not use GPG
      gnupg.sshKeyPaths = [];

      secrets = {
        michael_ssh_pubkeys = key "michael";
        shawn_ssh_pubkeys = key "shawn";
        root_ssh_pubkeys = key "root";
      };
    };

    # Sops-nix receives the protected SSH key from systemd-credentials
    systemd.services = {
      sops-install-secrets.serviceConfig = {
        LoadCredentialEncrypted = ["ssh_host_ed25519_key:/var/lib/systemd/credentials/ssh_host_ed25519_key"];
      };
      # Updates my local private secrets
      # Impure and imperative, attempt with caution
      secrets-update = {
        description = "Update secrets repository from remote";
        after = ["network-online.target"];
        wants = ["network-online.target"];

        serviceConfig = {
          Type = "oneshot";
        };

        environment = {
          GIT_CONFIG_COUNT = "1";
          GIT_CONFIG_KEY_0 = "safe.directory";
          GIT_CONFIG_VALUE_0 = "/etc/secrets";
        };

        path = with pkgs; [git openssh];

        # TODO: restart the install service when a diff gets pulled
        script = ''
          echo "[secrets-update] Checking for secrets repo in /etc/secrets"
          if [ ! -d /etc/secrets/.git ]; then
            echo "No git repo found in /etc/secrets; skipping pull"
            exit 0
          fi
          cd /etc/secrets/
          if [ -d .git ]; then
            if git pull --ff-only; then
              echo "[secrets-update] Pull successful"
            else
              echo "[secrets-update] Pull failed"
              exit 0
            fi
          fi
        '';
      };
    };

    systemd.timers.secrets-update = {
      description = "Timer for secrets repository updates";
      wantedBy = ["timers.target"];

      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "3h";
        Persistent = true;
      };
    };
  };
}
