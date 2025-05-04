{
  enableLSP = true;
  enableTreesitter = true;

  bash.enable = true;
  css.enable = true;
  html.enable = true;
  sql.enable = true;
  rust.enable = true;
  python.enable = true;
  yaml.enable = true;
  nix = import ./nix.nix;
}
