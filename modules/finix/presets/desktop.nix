{ nixosModules, ... }: {
  imports = [
    ./metal.nix
    ../graphical/hyprland.nix
    ../graphical/qt.nix
    ../security/tpm2.nix
    ../security/yubikey.nix
    ../system/btrfs.nix
    ../virtualization/containerlab.nix
  ]
  ++ (with nixosModules.packages; [
    base
    desktop
    dev
    fonts
    network
  ]);

  fonts.fontconfig.enable = true;
  hjem.users.michael.imports = [ ../../hjem/presets/nixos-desktop.nix ];
}
