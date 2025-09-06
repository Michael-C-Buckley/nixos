{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;
in {
  imports = [
    ./gpg.nix
    ./tpm2.nix
  ];

  environment = {
    etc = {
      "systemd/resolved.conf" = {
        source = mkForce config.sops.secrets.dns.path; # There is a conflict default source
        mode = "0644";
      };
    };
  };

  security = {
    apparmor.enable = false; # currently bugged for Incus profiles
    sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = mkDefault false;
    };
  };

  programs = {
    nix-ld.enable = mkDefault true;
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
    nftables.enable = true;
    firewall = {
      enable = mkDefault true;
      allowPing = mkDefault true;
      allowedTCPPorts = [22 53 5201];
      allowedUDPPorts = [53];
    };
  };
}
