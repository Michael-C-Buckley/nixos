{
  vim.languages = {
    enableTreesitter = true;

    bash.enable = true;
    yaml.enable = true;

    nix = {
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
    };
  };
}
