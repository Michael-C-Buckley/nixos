{
  enable = true;
  extraDiagnostics = {
    enable = true;
    types = [
      "statix"
      "deadnix"
    ];
  };
  format = {
    enable = true;
    type = "alejandra";
  };
  lsp.server = "nil";
}
