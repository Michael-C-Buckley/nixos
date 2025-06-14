{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals mkDefault;

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
  environment = {
    systemPackages = gpgPkgs ++ optionals notCloud yubikeyPkgs;
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
    pinentryPackage = mkDefault pkgs.pinentry-curses;
  };

  services = {
    pcscd.enable = notCloud;
    yubikey-agent.enable = false; # I'm using GPG for now
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
