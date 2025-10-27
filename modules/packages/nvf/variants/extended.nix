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
    };
  };
}
