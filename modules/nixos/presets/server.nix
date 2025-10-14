{inputs, ...}: {
  flake.nixosModules.serverPreset = {
    imports = with inputs.self.nixosModules; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs
      gpg-yubikey
      hjem-default
      hjem-root

      # WIP:
      packages
      serverPackages
    ];
  };
}
