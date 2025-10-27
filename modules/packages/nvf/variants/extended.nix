# Additional language server for development machines
{config, ...}: {
  flake.modules.nvf.extended = {
    imports = with config.flake.modules.nvf; [
      go
      python
      nix
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

      autocomplete = {
        enableSharedCmpSources = true;
        blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
        };
      };
    };
  };
}
