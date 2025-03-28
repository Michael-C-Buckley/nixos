{ config, pkgs, lib, ... }: let
  useFonts = config.features.pkgs.fonts;

  nerdFonts = with pkgs.nerd-fonts; lib.optionals useFonts [
    caskaydia-cove
    commit-mono
    fira-code
    jetbrains-mono
    symbols-only
    iosevka
    zed-mono
  ];
in {
  fonts.packages = with pkgs; lib.optionals useFonts [
    vista-fonts
    # maple-mono
    b612
    font-awesome
  ] ++ nerdFonts;
}
