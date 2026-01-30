{
  flake.modules.nixos.yubikey = {
    pkgs,
    lib,
    ...
  }: {
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
      ];
    };

    programs = {
      ssh = {
        startAgent = false;
        extraConfig = ''
          PKCS11Provider ${pkgs.yubico-piv-tool}/lib/libykcs11.so
        '';
      };
    };

    # Attempt to add the user's keys
    systemd.user.services.ssh-agent = {
      environment.SSH_AUTH_SOCK = "%t/ssh-agent";
      postStart = ''
        sleep 1
        ${pkgs.openssh}/bin/ssh-add
      '';
    };

    services = {
      gnome.gnome-keyring.enable = lib.mkForce false;
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
