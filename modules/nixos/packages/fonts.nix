{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    dejavu_fonts
    commit-mono
    vista-fonts
    font-awesome
    geist-font
    ibm-plex
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
    nerd-fonts.lilex
  ];
}
