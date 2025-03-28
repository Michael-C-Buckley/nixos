{inputs, ...}: {
  imports = [
    inputs.nixos-modules.nixosModules.zfs
    ./graphical
    ./gaming
  ];
}
