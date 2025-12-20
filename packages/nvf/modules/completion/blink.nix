{
  flake.modules.nvf.blink = {
    vim.autocomplete = {
      enableSharedCmpSources = true;
      blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
      };
    };
  };
}
