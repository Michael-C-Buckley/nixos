# Run at the system level so that I may use systemd-creds to protect my key
# This is a key stub that points to a yubikey, so leakage is not an issue
# but just another layer of due diligence
# I do also use secureboot so TPM2 PCR7 is in effect and only decrypts with
# a proper boot state
{
  flake.modules.nixos.michael-ssh-agent = {
    pkgs,
    lib,
    ...
  }: let
    keyBase = "${pkgs.openssh}/bin/ssh-add /run/credentials/ssh-agent-michael.service/id_ed25519_sk_";
    mkCred = key_variant: "id_ed25519_sk_${key_variant}:/home/michael/.ssh/crypt/id_ed25519_sk_${key_variant}";
    keyTypes = ["signing" "internal" "github"];

    link_script = pkgs.writers.writePython3 "ssh_link_script" {} ./ssh_link.py;
  in {
    # Simplify my custom agent with a simple user agent for internal hosts
    hjem.users.michael.systemd.services = {
      ssh-agent-internal = let
        internal = "/home/michael/.ssh/agent/internal.sock";
      in {
        description = "SSH Agent for internal hosts";
        wantedBy = ["multi-user.target"];
        after = ["local-fs.target"];

        path = with pkgs; [openssh busybox yubikey-manager];

        preStart = ''
          mkdir -p /home/michael/.ssh/agent
          rm -f ${internal}
        '';

        postStart = ''
          ${link_script}
          ssh-add /home/michael/.ssh/active/internal
        '';

        serviceConfig = {
          Type = "forking";
          Environment = "SSH_AUTH_SOCK=/home/michael/.ssh/agent/internal.sock";
          ExecStart = ''${pkgs.openssh}/bin/ssh-agent -a ${internal}'';
        };
      };
    };
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="hidraw", ENV{ID_VENDOR_ID}=="1050", ENV{SYSTEMD_WANTS}+="yubikey-link.service", TAG+="systemd"
    '';

    systemd.services = {
      yubikey-link = {
        description = "Update Yubikey symlinks";
        path = with pkgs; [busybox yubikey-manager];
        serviceConfig = {
          User = "michael";
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "yubikey-linkstart" ''
            sleep 1
            ykman list
            ${link_script} ${lib.getExe pkgs.yubikey-manager}
          '';
        };
      };
      ssh-agent-michael = {
        description = "SSH Agent for michael";
        wantedBy = ["multi-user.target"];
        after = ["local-fs.target"];

        postStart = ''
          # Add all generic keys
          ${pkgs.openssh}/bin/ssh-add
          # Add protected stubs
          ${builtins.concatStringsSep "\n"
            (map (key: "${keyBase}${key}") keyTypes)}
        '';

        serviceConfig = {
          Type = "forking";
          User = "michael";
          RuntimeDirectory = "ssh-agent-michael";
          Environment = "SSH_AUTH_SOCK=/home/michael/.ssh/custom-agent.sock";
          ExecStart = "${pkgs.openssh}/bin/ssh-agent -a $SSH_AUTH_SOCK";
          LoadCredentialEncrypted = map mkCred keyTypes;
        };
      };
    };
  };
}
