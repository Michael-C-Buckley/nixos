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

      # WIP:
      packages
    ];
  };
}
