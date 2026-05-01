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

    environment.systemPackages = [
      pkgs.python3
      config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vim
    ];

    services.resolved.enable = false;
  };
}
