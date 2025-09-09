{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./gpg.nix
    ./tpm2.nix
  ];

  security = {
    sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = mkDefault false;
    };
  };

  services = {
    # Farewell printing, read this article if you didn't know you could print with just netcat
    # https://retrohacker.substack.com/p/bye-cups-printing-with-netcat
    printing.enable = false;
    openssh = {
      enable = mkDefault true;
      settings = {
        PasswordAuthentication = mkDefault false;
        KbdInteractiveAuthentication = mkDefault false;
        streamLocalBindUnlink = mkDefault true;
      };
    };
  };

  networking = {
    firewall = {
      # Blocking ICMP is very dumb overall
      allowPing = mkDefault true;
      allowedTCPPorts = [22 53];
      allowedUDPPorts = [53];
    };
  };
}
