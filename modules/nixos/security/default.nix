{
  flake.modules.nixos.security = {
    config,
    lib,
    ...
  }: {
    boot.initrd.systemd.emergencyAccess = config.users.users.root.hashedPassword;

    security.sudo.extraConfig = "Defaults lecture=never";

    services = {
      # Farewell printing, read this article if you didn't know you could print with just netcat
      # https://retrohacker.substack.com/p/bye-cups-printing-with-netcat
      printing.enable = false;
      openssh = with lib; {
        enable = mkDefault true;
        openFirewall = mkDefault true;
        settings = {
          PasswordAuthentication = mkDefault false;
          KbdInteractiveAuthentication = mkDefault false;
          streamLocalBindUnlink = mkDefault true;
        };
      };
    };
    networking.firewall.allowPing = true;
  };
}
