{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;
in {
  imports = with inputs; [
    sops-nix.nixosModules.sops
    nix-secrets.nixosModules.ssh
    nix-secrets.nixosModules.common
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
    printing.enable = false; # Revoke printing for its flaws over the years
    openssh = {
      enable = mkDefault true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22 53];
      allowedUDPPorts = [53];
    };
  };
}
