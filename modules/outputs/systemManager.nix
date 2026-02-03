{
  config,
  inputs,
  ...
}: let
  system-manager = import config.flake.npins.system-manager {inherit (inputs) nixpkgs;};
in {
  flake.systemConfigs = {
    debian = system-manager.lib.makeSystemConfig {
      extraSpecialArgs = {inherit inputs;};
      modules = with config.flake.modules.systemManager; [
        nix
        packages
        debian
        #fish # Currently experimental
      ];
    };
  };
}
