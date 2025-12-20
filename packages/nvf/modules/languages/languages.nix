{
  flake.modules.nvf.languages = {
    vim = {
      lsp = {
        enable = true;
        formatOnSave = true;
      };
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        bash.enable = true;
        yaml.enable = true;
      };
      treesitter = {
        enable = true;
        context.enable = true;
        fold = true;
      };
      keymaps = [
        {
          mode = "n";
          key = "<leader>lf";
          action = ":lua vim.lsp.buf.format()<CR>";
          silent = true;
        }
      ];
    };
  };
}
