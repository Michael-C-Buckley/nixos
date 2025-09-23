{
  vim.languages = {
    enableTreesitter = true;

    bash.enable = true;
    yaml.enable = false;

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
