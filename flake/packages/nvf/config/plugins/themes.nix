{pkgs}: let
  createTheme = name: package: {
    inherit package;
    setup = "require('${name}').setup {}";
  };
  # For simple Vim colorschemes
  basicTheme = package: {
    inherit package;
  };
in
  with pkgs.vimPlugins; {
    kanagawa = createTheme "kanagawa" kanagawa-nvim;
    ayu = createTheme "ayu" neovim-ayu;
    nightfox = createTheme "nightfox" nightfox-nvim;
    rose-pine = createTheme "rose-pine" rose-pine;
    catppuccin = createTheme "catppuccin" catppuccin-nvim;
    gruvbox = createTheme "gruvbox" gruvbox-nvim;
    starrynight = basicTheme starrynight;
  }
