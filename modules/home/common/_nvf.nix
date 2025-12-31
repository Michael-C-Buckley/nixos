# WIP module - Not imported
# I need to align my flake modules to actually plumb
# correctly to this interface
{inputs, ...}: {
  flake.modules.homeManager.nvf = {
    imports = [inputs.nvf.homeManagerModules.default];
  };

  programs.nvf = {
    enable = true;
    defaultEditor = true;
    #settings = import config.flake.modules.nvf.full;
  };
}
