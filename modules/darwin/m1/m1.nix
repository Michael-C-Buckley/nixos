{
  config,
  inputs,
  ...
}: {
  flake.darwinConfigurations.m1 = inputs.nix-darwin.lib.darwinSystem {
    modules = with config.flake.modules.darwin; [
      default
      vscode
    ];
  };
}
