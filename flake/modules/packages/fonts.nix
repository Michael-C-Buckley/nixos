{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;

  useFonts = config.features.pkgs.fonts;

  extraFonts = with pkgs; [
    dejavu_fonts
    vista-fonts
    font-awesome
    geist-font
    cascadia-code
    noto-fonts

    nerd-fonts.meslo-lg
    nerd-fonts.symbols-only
  ];
in {
  fonts.packages =
    # Unconditionally make Jetbrains Mono available for basic things like Ghostty
    [pkgs.nerd-fonts.jetbrains-mono]
    ++ optionals useFonts extraFonts;
}
