{pkgs, ...}: let
  createTheme = name: package: {
    inherit package;
    setup = "require('${name}').setup {}";
  };
  # For simple Vim colorschemes
  basicTheme = package: {
    inherit package;
  };
in {
  vim = {
    startPlugins = with pkgs.vimPlugins; [
      everforest
      iceberg-vim
    ];

    extraPlugins = with pkgs.vimPlugins;
      {
        kanagawa = createTheme "kanagawa" kanagawa-nvim;
        ayu = createTheme "ayu" neovim-ayu;
        nightfox = createTheme "nightfox" nightfox-nvim;
        rose-pine = createTheme "rose-pine" rose-pine;
        catppuccin = createTheme "catppuccin" catppuccin-nvim;
        gruvbox = createTheme "gruvbox" gruvbox-nvim;
        starrynight = basicTheme starrynight;
      }
      // {
        nordic = {
          package = pkgs.vimPlugins.nordic-nvim;
          setup = ''
            require('nordic').colorscheme({
              underline_option = 'none',
              italic = true,
              italic_comments = false,
              minimal_mode = false,
              alternate_backgrounds = false
            })
          '';
        };
      };
  };
}
