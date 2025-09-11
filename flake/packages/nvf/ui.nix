{
  vim = {
    options.tabstop = 4;

    dashboard.alpha = {
      enable = true;
      theme = "theta";
    };

    comments.comment-nvim.enable = true;
    statusline.lualine.enable = true;
    tabline.nvimBufferline.enable = true;

    # Navigation
    projects.project-nvim.enable = true;
    telescope.enable = true;
    navigation.harpoon.enable = true;
    filetree.neo-tree.enable = true;

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
    };

    ui = {
      borders.enable = true;
      colorizer.enable = true;
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
}
