{
  flake.modules.nvf.plugins = {pkgs, ...}: {
    vim = {
      startPlugins = with pkgs.vimPlugins; [
        transparent-nvim
      ];
    };
  };
}
