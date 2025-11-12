# Additional language server for development machines
{config, ...}: {
  flake.modules.nvf.extended = {
    imports = with config.flake.modules.nvf; [
      default
      go
      python
      nix
      languages
    ];

    vim = {
      runner.run-nvim = {
        enable = true;
      };

      # To try out
      notes = {
        obsidian.enable = false; # Currently bugged
        orgmode.enable = true;
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
