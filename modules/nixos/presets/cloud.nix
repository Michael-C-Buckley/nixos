{config, ...}: {
  flake.modules.nixos.cloudPreset = {
    imports = with config.flake.modules.nixos; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs
      hjem-default
      hjem-root
      shawn

      # WIP:
      packages
    ];
  };
}
