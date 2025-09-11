{pkgs, ...}: {
  vim = {
    lazy.plugins = {
      "telescope-undo.nvim".package = pkgs.vimPlugins.telescope-undo-nvim;
    };
  };
}
