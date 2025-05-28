{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce optionals;

  notCloud = config.system.preset != "cloud";

  gpgPkgs = with pkgs; [
    gnupg
    pinentry-curses
    opensc
  ];

  yubikeyPkgs = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    libp11
  ];
in {
  imports = with inputs; [
    sops-nix.nixosModules.sops
    nix-secrets.nixosModules.ssh
    nix-secrets.nixosModules.common
  ];

  services.resolved.enable = true;

  environment = {
    systemPackages = gpgPkgs ++ optionals notCloud yubikeyPkgs;
    etc = {
      "pkcs11/pkcs11.conf".text = ''
        module: ${pkgs.opensc}/lib/opensc-pkcs11.so
        critical: yes
        log-calls: yes
      '';
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

    # https://github.com/NixOS/nixpkgs/issues/290926
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_card") {
          return polkit.Result.YES;
        }
      });

      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_pcsc") {
          return polkit.Result.YES;
        }
      });
    '';
  };

  #hardware.gpgSmartcards.enable = notCloud;

  programs = {
    nix-ld.enable = mkDefault true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = notCloud;
      pinentryPackage = mkDefault pkgs.pinentry-curses;
    };
  };

  services = {
    pcscd.enable = notCloud;
    yubikey-agent.enable = notCloud;
    printing.enable = false; # Revoke printing for its flaws over the years
    openssh.enable = mkDefault true;
    udev.packages = optionals notCloud [pkgs.yubikey-personalization];
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
