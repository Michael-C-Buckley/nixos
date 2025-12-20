# Additional language server for development machines
{config, ...}: {
  flake.modules.nvf.extended = {
    imports = with config.flake.modules.nvf; [
      default
      blink
      go
      python
      nix
      themes
      languages
    ];

    vim = {
      runner.run-nvim = {
        enable = true;
      };

      lsp = {
        enable = true;
        formatOnSave = true;
      };
    };
  };
}
