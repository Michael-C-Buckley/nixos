# Additional language server for development machines
{config, ...}: {
  flake.modules.nvf.extended = {
    imports = with config.flake.modules.nvf; [
      default
      blink
      themes
      transparent
      neotree
      languages
      go
      python
      nix
    ];
  };
}
