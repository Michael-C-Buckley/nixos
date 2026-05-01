{
  flake.modules.nixos.security = {
    config,
    lib,
    ...
  }: {
    boot.initrd.systemd.emergencyAccess = true;

    security.sudo.extraConfig = "Defaults lecture=never";

    # See: https://www.openwall.com/lists/oss-security/2025/12/28/4
    systemd = lib.mkIf config.services.openssh.enable {
      generators.systemd-ssh-generator = "/dev/null";
      sockets.sshd-unix-local.enable = lib.mkForce false;
      sockets.sshd-vsock.enable = lib.mkForce false;
    };

    services = {
      # Farewell printing, read this article if you didn't know you could print with just netcat
      # https://retrohacker.substack.com/p/bye-cups-printing-with-netcat
      printing.enable = false;

      openssh = with lib; {
        enable = mkDefault true;
        openFirewall = mkDefault true;
        settings = {
          KbdInteractiveAuthentication = mkDefault false;
          streamLocalBindUnlink = mkDefault true;
        };
      };
    };
    networking.firewall.allowPing = true;
  };
}
