{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) concatLists;
  inherit (lib) optionals;

  useFonts = config.features.pkgs.fonts;

  extraNerdFonts = with pkgs.nerd-fonts; [
    caskaydia-cove
    symbols-only
  ];

  extraFonts = with pkgs; [
    dejavu_fonts
    vista-fonts
    #font-awesome
  ];
in {
  fonts.packages =
    # Unconditionally make Jetbrains Mono available for basic things like Ghostty
    [pkgs.nerd-fonts.jetbrains-mono]
    ++ optionals useFonts (concatLists [extraNerdFonts extraFonts]);
}
