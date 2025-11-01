{
  flake.modules.nvf.ui = {
    vim = {
      dashboard.alpha = {
        enable = true;
        theme = "theta";
      };

      comments.comment-nvim.enable = true;
      statusline.lualine.enable = true;
      tabline.nvimBufferline.enable = true;

      # Navigation
      projects.project-nvim.enable = true;
      navigation.harpoon.enable = true;
      filetree.neo-tree.enable = true;
      telescope = {
        enable = true;
        mappings = {
          gitBranches = "<leader>gb";
          gitStatus = "<leader>gs";
        };
      };

      theme.enable = false;

      ui = {
        borders.enable = true;
        illuminate.enable = true;
        fastaction.enable = true;
        smartcolumn = {
          enable = true;
          setupOpts.custom_colorcolumn = {
            nix = "110";
            go = ["90" "130"];
            python = ["80" "120"];
          };
        };

        colorizer = {
          enable = true;
          setupOpts.filetypes = {
            "*" = {
              mode = "background";
              tailwind = true;
              names = true;
              RGB = true;
              RRGGBB = true;
            };
          };
        };

        noice.enable = true;
        breadcrumbs = {
          enable = true;
          lualine.winbar.enable = true;
          navbuddy.enable = true;
        };
      };

      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;

        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        rainbow-delimiters.enable = true;
      };
    };
  };
}
