{inputs, ...}: {
  imports = with inputs.nixos-modules.nixosModules; [
    zfs
    ./desktops
    ./display.nix
    ./gaming.nix
  ];
}
