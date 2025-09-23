{pkgs, ...}: let
  inherit (pkgs) vimPlugins;
in {
  vim = {
    lazy.plugins = {
      everforest.package = vimPlugins.everforest;
      "kanagawa.nvim".package = vimPlugins.kanagawa-nvim;
      "rose-pine".package = vimPlugins.rose-pine;
      "neovim-ayu".package = vimPlugins.neovim-ayu;
      "catppuccin-nvim".package = vimPlugins.catppuccin-nvim;
      "gruvbox.nvim".package = vimPlugins.gruvbox-nvim;
      "starrynight".package = vimPlugins.starrynight;
      "nordic.nvim" = {
        package = vimPlugins.nordic-nvim;
        setupOpts = ''
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
