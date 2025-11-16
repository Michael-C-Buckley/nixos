{config, ...}: let
  inherit (config.flake.modules) nixos nvf;
  inherit (config.flake.modules) hjem;
in {
  flake.modules.nixos.serverPreset = {
    imports = with nixos;
      [
        linuxPreset
        network
        users
        boot
        impermanence
        zfs
        gpg-yubikey
        shawn

        # WIP:
        packages
        packages-server
        packages-physical
        packages-network
      ]
      ++ (with hjemModules; [
        default
        root
      ]);

    programs.nvf.settings.imports = with nvf; [default];
  };
}
