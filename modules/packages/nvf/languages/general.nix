{
  flake.modules.nvf.languages = {
    vim.languages = {
      enableFormat = true;
      enableTreesitter = true;

      bash.enable = true;
      yaml.enable = true;
    };
  };
}
