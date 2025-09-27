{
  flake.modules.nixos.packages.fonts = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (builtins) elem;
    inherit (lib) optionals;
    inherit (config.system) preset;

    useFonts = elem preset ["desktop" "laptop"];

    extraFonts = with pkgs; [
      dejavu_fonts
      vista-fonts
      font-awesome
      geist-font
      cascadia-code
      noto-fonts

      nerd-fonts.symbols-only
      nerd-fonts.lilex
    ];
  in {
    fonts.packages =
      # Unconditionally make Jetbrains Mono available for basic things like Ghostty
      [pkgs.nerd-fonts.jetbrains-mono]
      ++ optionals useFonts extraFonts;
  };
}
