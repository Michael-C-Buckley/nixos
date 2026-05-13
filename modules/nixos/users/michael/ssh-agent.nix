{
  flake.modules.nixos.michael-ssh-agent = {
    pkgs,
    lib,
    ...
  }: let
    link_script = pkgs.writers.writePython3 "ssh_link_script" {} ./ssh_link.py;
  in {
    # Simplify my custom agent with a simple user agent
    hjem.users.michael = {
      environment.sessionVariables = {
        SSH_AUTH_SOCK = "/home/michael/.ssh/agent/standard.sock";
      };
      systemd.services = {
        ssh-agent-internal = let
          internal = "/home/michael/.ssh/agent/standard.sock";
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
            ssh-add /home/michael/.ssh/active/external
            ssh-add /home/michael/.ssh/active/github
            ssh-add /home/michael/.ssh/active/signing
          '';

          serviceConfig = {
            Type = "forking";
            Environment = "SSH_AUTH_SOCK=/home/michael/.ssh/agent/standard.sock";
            ExecStart = ''
              ${pkgs.openssh}/bin/ssh-agent -a ${internal}
            '';
          };
        };
      };
    };
    services = {
      gnome.gcr-ssh-agent.enable = false;
      udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="hidraw", ENV{ID_VENDOR_ID}=="1050", ENV{SYSTEMD_WANTS}+="yubikey-link.service", TAG+="systemd"
      '';
    };

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
    };
  };
}
