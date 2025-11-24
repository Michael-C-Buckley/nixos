{
  config,
  inputs,
  ...
}: {
  flake.homeConfigurations = {
    "michael@alpine" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      modules = with config.flake.modules.homeManager; [
        alpine
        default
      ];
    };
  };
}
