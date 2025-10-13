{inputs, ...}: {
  flake.nixosModules.cloudPreset = {
    imports = with inputs.self.nixosModules; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs

      # WIP:
      packages
    ];
  };
}
