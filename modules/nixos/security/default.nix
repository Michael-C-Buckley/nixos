{
  flake.nixosModules.security = {lib, ...}: {
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
        openFirewall = mkDefault true;
        settings = {
          PasswordAuthentication = mkDefault false;
          KbdInteractiveAuthentication = mkDefault false;
          streamLocalBindUnlink = mkDefault true;
        };
      };
    };

    # Blocking ICMP is very dumb overall
    networking.firewall.allowPing = true;
  };
}
