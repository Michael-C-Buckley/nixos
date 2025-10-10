# I use GPG quite a bit nowadays and here's a module for getting the components to work correctly
#  Hardware devices are enabled on anything that isn't a cloud node
#  My primary use are my yubikeys but I also have TPM-sealed GPG keys
{
  flake.modules.nixosModules = {
    gpg = {pkgs, ...}: {
      environment.systemPackages = [pkgs.gnupg];

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    gpg-yubikey = {pkgs, ...}: {
      environment = {
        etc."pkcs11/pkcs11.conf".text = ''
          module: ${pkgs.opensc}/lib/opensc-pkcs11.so
          critical: yes
          log-calls: yes
        '';

        systemPackages = with pkgs; [
          yubikey-manager
          yubikey-personalization
          yubico-piv-tool
          yubikey-agent
          libp11
          # TPM
          p11-kit
          gnupg-pkcs11-scd
        ];

        programs.gnupg.agent.enableBrowserSocket = true;

        hardware.gpgSmartcards.enable = true;

        services = {
          pcscd.enable = true;
          yubikey-agent.enable = false;
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
    };
  };
}
