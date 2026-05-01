{config, ...}: let
  inherit (config.flake) modules;
in {
  flake.modules.nixos.serverPreset = {pkgs, ...}: {
    imports = builtins.attrValues {
      inherit
        (modules.nixos)
        linuxPreset
        network
        zfs
        shawn
        packages
        packages-network
        # Security
        clamav
        yubikey
        secrets
        pam-ssh
        # Users
        michael-attic
        hjem
        ;
    };

    #boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_19; # Deprecated, will fall back to 6.18 LTS

    environment.systemPackages = [
      pkgs.python3
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vim
    ];

    services = {
      resolved.enable = false;
      gnome.gnome-keyring.enable = false;
    };
  };
}
