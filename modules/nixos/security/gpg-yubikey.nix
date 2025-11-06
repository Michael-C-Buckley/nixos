# I use GPG quite a bit nowadays and here's a module for getting the components to work correctly
#  Hardware devices are enabled on anything that isn't a cloud node
#  My primary use are my yubikeys but I also have TPM-sealed GPG keys
{
  flake.modules.nixos.gpg-yubikey = {pkgs, ...}: {
    environment = {
      etc."pkcs11/pkcs11.conf".text = ''
        module: ${pkgs.opensc}/lib/opensc-pkcs11.so
        critical: yes
        log-calls: yes
      '';

      systemPackages = with pkgs; [
        yubikey-manager
        libfido2
        yubikey-personalization
        yubico-piv-tool
        libp11
        age-plugin-yubikey
        # TPM
      ];
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
    };

    hardware.gpgSmartcards.enable = true;

    services = {
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
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
  };
}
