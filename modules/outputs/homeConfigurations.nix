# I only use Home-Manager on non-NixOS hosts and quite rarely
# Hjem is my go-to for NixOS and Nix-Darwin
# I will eventually move to Hjem standalone whenever the project
# releases that
{
  config,
  inputs,
  ...
}: let
  # This is a very specific import of the module that creates home configurations
  # I am able to avoid having HM as a full flake input and extracting the small segment
  # needed helps reduce evaluation overhead for the majority of things that don't use it
  home-manager = import "${config.flake.npins.home-manager}/lib" {inherit (inputs.nixpkgs) lib;};

  inherit (builtins) mapAttrs;
  inherit (config) flake;

  inherit (config.flake.modules.homeManager) alpine debian gentoo;
  mkHmConfig = {
    system,
    modules,
  }: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
    home-manager.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        # This intentionally does not collide with `lib`
        flakeLib = flake.lib;
        # These require pkgs to be passed so collect and do once to get the ready functions
        functions = mapAttrs (_: v: v {inherit pkgs;}) flake.functions;
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
