{
  flake.modules.nixos.security = {
    config,
    pkgs,
    lib,
    ...
  }: {
    boot.initrd.systemd.emergencyAccess = config.users.users.root.hashedPassword;

    security.sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = false;
    };

    services = {
      # Farewell printing, read this article if you didn't know you could print with just netcat
      # https://retrohacker.substack.com/p/bye-cups-printing-with-netcat
      printing.enable = false;
      openssh = with lib; {
        enable = mkDefault true;
        package = pkgs.openssh_10_2; # Fixes control socket issue: https://www.openssh.org/releasenotes.html#10.2p1
        openFirewall = mkDefault true;
        settings = {
          PasswordAuthentication = mkDefault false;
          KbdInteractiveAuthentication = mkDefault false;
          streamLocalBindUnlink = mkDefault true;
        };
      };
    };

    # For getting around the socket issues
    environment.systemPackages = [pkgs.openssh_10_2];

    # Blocking ICMP is very dumb overall
    networking.firewall.allowPing = true;
  };
}
