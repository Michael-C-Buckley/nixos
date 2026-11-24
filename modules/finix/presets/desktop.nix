{
  imports = [
    ./metal.nix
    ../graphical/hyprland.nix
    ../graphical/qt.nix
    ../security/tpm2.nix
    ../security/yubikey.nix
    ../system/btrfs.nix
    ../virtualization/containerlab.nix
    ../../nixos/packages/base.nix
    ../../nixos/packages/desktop.nix
    ../../nixos/packages/dev.nix
    ../../nixos/packages/fonts.nix
    ../../nixos/packages/network.nix
  ];

  fonts.fontconfig.enable = true;
  hjem.users.michael.imports = [ ../../hjem/presets/nixos-desktop.nix ];
}
