{config, lib, ...}: let
  inherit (lib) mkIf mkMerge;
  hyprland = config.features.michael.hyprland.enable;
in mkMerge [
  (import ./nix/standard.nix)
  (mkIf hyprland (import ./nix/hyprland.nix))
]