{inputs, ...}: {
  flake.modules.nixos.cloudPreset = {
    imports = with inputs.self.modules.nixos; [
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
