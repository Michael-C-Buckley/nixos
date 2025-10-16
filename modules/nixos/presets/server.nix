{inputs, ...}: {
  flake.modules.nixos.serverPreset = {
    imports = with inputs.self.modules.nixos; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs
      gpg-yubikey
      hjem-default
      hjem-root
      shawn

      # WIP:
      packages
      serverPackages
    ];
  };
}
