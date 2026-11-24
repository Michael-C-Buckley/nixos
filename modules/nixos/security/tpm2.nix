let
  socket = "/run/ssh-tpm-agent.sock";
in
{ config, pkgs, ... }:
let
  extraGroups = [ "tss" ];
  cfg = config.services.ssh-host-tpm-agent;
in
{
  imports = [ (import ./_ssh-host-tpm-agent.nix "/etc/ssh") ];

  environment.systemPackages = with pkgs; [
    ssh-tpm-agent
    tpm2-tools
    age-plugin-tpm
  ];

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  users.users = {
    michael = { inherit extraGroups; };
    shawn = { inherit extraGroups; };
  };

  systemd = {
    sockets.ssh-host-tpm-agent = {
      description = "SSH TPM Agent Socket";

      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = socket;
        SocketMode = "0600";
        SocketUser = "root";
        SocketGroup = "root";
      };
    };

    services.ssh-host-tpm-agent = {
      description = "SSH TPM Host Key Agent";

      requires = [ "ssh-host-tpm-agent.socket" ];
      after = [ "ssh-host-tpm-agent.socket" ];

      serviceConfig = {
        Type = "simple";
        User = "root";

        ExecStart = ''
          ${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent \
            --key-dir ${cfg.keyDirectory} -l ${socket}
        '';

        Restart = "on-failure";
        RestartSec = 2;

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
      };
    };
  };

  services.openssh = {
    enable = true;
    hostKeys = [ ];
    # Keep the existing host keys during migration.
    # NixOS will continue to generate these if necessary.
    extraConfig = ''
      HostKeyAgent ${socket}
      HostKey ${cfg.keyDirectory}/${cfg.keyName}.pub
    '';
  };
}
