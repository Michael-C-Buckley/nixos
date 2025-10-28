{config, ...}: let
  inherit (config.flake) packages;
in {
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
        # Custom packages I added and overlaid
        "kanso-nvim".package = packages.${pkgs.system}.kanso-nvim;
        "thorn-nvim".package = packages.${pkgs.system}.thorn-nvim;
        # Nixpkgs items
        everforest.package = vimPlugins.everforest;
        "lackluster.nvim".package = vimPlugins.lackluster-nvim;
        "kanagawa.nvim".package = vimPlugins.kanagawa-nvim;
        "neovim-ayu".package = vimPlugins.neovim-ayu;
        "catppuccin-nvim".package = vimPlugins.catppuccin-nvim;
        "gruvbox.nvim".package = vimPlugins.gruvbox-nvim;
      };
    };
  };
}
