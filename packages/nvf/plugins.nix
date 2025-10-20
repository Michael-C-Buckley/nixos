{pkgs, ...}: {
  vim = {
    startPlugins = with pkgs.vimPlugins; [
      transparent-nvim
    ];
    lazy.plugins = {
      "telescope-undo.nvim".package = pkgs.vimPlugins.telescope-undo-nvim;
    };
  };
}
