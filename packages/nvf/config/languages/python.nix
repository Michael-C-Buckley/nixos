{
  flake.modules.nvf.python = {
    vim.languages = {
      python = {
        enable = true;
        dap.enable = true;
        format.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
    };
  };
}
