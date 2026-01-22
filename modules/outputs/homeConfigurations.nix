{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules.homeManager) alpine default gentoo wsl;
  mkHmConfig = {
    system,
    modules,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      inherit modules;
    };
in {
  flake.homeConfigurations = {
    "michael@gentoo" = mkHmConfig {
      system = "x86_64-linux";
      modules = [
        gentoo
        default
        wsl
      ];
    };

    "michael@alpine" = mkHmConfig {
      system = "x86_64-linux";
      modules = [
        alpine
        default
      ];
    };
  };
}
