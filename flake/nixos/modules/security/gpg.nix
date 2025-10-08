# I use GPG quite a bit nowadays and here's a module for getting the components to work correctly
#  Hardware devices are enabled on anything that isn't a cloud node
#  My primary use are my yubikeys but I also have TPM-sealed GPG keys
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals;

  notCloud = config.system.preset != "cloud";

  gpgPkgs = with pkgs; [
    gnupg
    pinentry-curses
    opensc
  ];

  tpmPkgs = with pkgs; [
    p11-kit
    gnupg-pkcs11-scd
  ];

  yubikeyPkgs = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    yubikey-agent
    libp11
  ];
in {
  environment = {
    systemPackages =
      gpgPkgs
      ++ optionals notCloud yubikeyPkgs
      ++ optionals config.security.tpm2.enable tpmPkgs;
    etc."pkcs11/pkcs11.conf".text = ''
      module: ${pkgs.opensc}/lib/opensc-pkcs11.so
      critical: yes
      log-calls: yes
    '';
  };

  hardware.gpgSmartcards.enable = notCloud;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableBrowserSocket = notCloud;
    pinentryPackage = pkgs.pinentry-curses;
  };

  services = {
    pcscd.enable = notCloud;
    yubikey-agent.enable = false;
    udev.packages = optionals notCloud [pkgs.yubikey-personalization];
  };

  # https://github.com/NixOS/nixpkgs/issues/290926
  security.polkit.extraConfig = ''
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
}
