{
  flake.nixosModules.fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      jetbrains-mono
      dejavu_fonts
      vista-fonts
      font-awesome
      geist-font
      cascadia-code
      noto-fonts

      nerd-fonts.symbols-only
      nerd-fonts.lilex
    ];
  };
}
