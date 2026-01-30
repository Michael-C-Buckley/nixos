{
  config,
  inputs,
  ...
}: let
  home-manager = import "${config.flake.npins.home-manager}/lib" {inherit (inputs.nixpkgs) lib;};
  inherit (config.flake.modules.homeManager) alpine debian gentoo;
  mkHmConfig = {
    system,
    modules,
  }:
    home-manager.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      inherit modules;
    };
in {
  flake.homeConfigurations = {
    "michael@t14" = mkHmConfig {
      system = "x86_64-linux";
      modules = [gentoo];
    };

    "michael@alpine" = mkHmConfig {
      system = "x86_64-linux";
      modules = [alpine];
    };

    "michael@debian" = mkHmConfig {
      system = "x86_64-linux";
      modules = [debian];
    };
  };
}
