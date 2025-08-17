{pkgs, ...}: {
  vim = {
    keymaps = import ./keymaps/basic.nix;
    extraPlugins = import ./plugins {inherit pkgs;};
    startPlugins = with pkgs.vimPlugins; [
      everforest
    ];

    lazy.plugins."telescope-undo.nvim" = {
      package = pkgs.vimPlugins.telescope-undo-nvim;
    };

    options.tabstop = 4;

    # Navigation
    projects.project-nvim.enable = true;
    telescope.enable = true;
    navigation.harpoon.enable = true;

    # Utility
    autopairs.nvim-autopairs.enable = true;
    comments.comment-nvim.enable = true;
    statusline.lualine.enable = true;

    notes = {
      todo-comments.enable = true;
    };

    #Clipboard
    clipboard = {
      enable = true;
      registers = "unnamedplus";
    };

    # Appearance
    theme = {
      # NVF Default is `onedark`
      enable = true;
      name = "onedark";
      style = "dark";
    };

    ui = {
      borders.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
      fastaction.enable = true;
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          go = ["90" "130"];
          python = ["80" "120"];
        };
      };
    };

    utility = {
      mkdir.enable = true;
      nix-develop.enable = true;
      oil-nvim.enable = true;
    };

    treesitter = {
      enable = true;
      context.enable = true;
      fold = true;
    };

    git = {
      enable = true;
      git-conflict.enable = true;
      gitsigns.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    lsp.enable = true;

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
    };
  };
}
