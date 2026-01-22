{
  config,
  inputs,
  ...
}: {
  flake.modules.homeManager.nvf = {
    imports = [inputs.nvf.homeManagerModules.default];

    programs.nvf = {
      enable = true;
      defaultEditor = true;
      settings.imports = with config.flake.modules.nvf; [full];
    };
  };
}
