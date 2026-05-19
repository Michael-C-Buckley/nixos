{inputs, ...}: let
  inherit (import ../utility {inherit inputs;}) systems;
in
  inputs.nixpkgs.lib.genAttrs systems.all (
    system: {
      default = import ../shell.nix {pkgs = import inputs.nixpkgs {inherit system;};};
    }
  )
