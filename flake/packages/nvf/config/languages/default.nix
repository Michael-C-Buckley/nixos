{
  enableTreesitter = true;

  bash.enable = true;
  css.enable = true;
  html.enable = true;
  sql.enable = true;
  rust.enable = true;
  yaml.enable = true;
  nix = import ./nix.nix;

  python = {
    enable = true;
    dap.enable = true;
    format.enable = true;
    lsp.enable = true;
    treesitter.enable = true;
  };
}
