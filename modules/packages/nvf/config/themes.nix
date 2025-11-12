{
  flake.modules.nvf.themes = {pkgs, ...}: let
    inherit (pkgs) vimPlugins;
  in {
    vim = {
      extraPlugins = {
        ayu = {
          package = vimPlugins.neovim-ayu;
          setup = ''
            require('ayu').setup{}
            vim.cmd.colorscheme("ayu")
          '';
        };
      };
      lazy.plugins = {
        "kanso.nvim".package = vimPlugins.kanso-nvim;
        everforest.package = vimPlugins.everforest;
        "lackluster.nvim".package = vimPlugins.lackluster-nvim;
        "kanagawa.nvim".package = vimPlugins.kanagawa-nvim;
        "catppuccin-nvim".package = vimPlugins.catppuccin-nvim;
        "gruvbox.nvim".package = vimPlugins.gruvbox-nvim;
      };
    };
  };
}
