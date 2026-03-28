{
  flake.modules.nixos.packages-fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      jetbrains-mono
      dejavu_fonts
      vista-fonts
      font-awesome
      geist-font
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      nerd-fonts.symbols-only
      nerd-fonts.lilex
    ];
  };
}
