let
  key = name: {
    sopsFile = "/etc/secrets/users/${name}/ssh_pubkeys.sops";
    mode = "0644";
    format = "binary";
  };
in {
  flake.modules.nixos.secrets = {pkgs, ...}: {
    sops.secrets = {
      michael_ssh_pubkeys = key "michael";
      shawn_ssh_pubkeys = key "shawn";
      root_ssh_pubkeys = key "root";
    };

    # Updates my local private secrets
    # Impure and imperative, attempt with caution
    systemd.services.secrets-update = {
      description = "Update secrets repository from remote";
      after = ["network-online.target"];
      wants = ["network-online.target"];

      serviceConfig = {
        Type = "oneshot";
      };

      path = with pkgs; [git openssh];

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
