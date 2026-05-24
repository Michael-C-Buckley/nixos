{
  description = "Michael's System Flake";

  outputs = inputs: let
    inherit (import ./lib/flake {inherit inputs;}) mkModule;
    nixosModules = mkModule ./modules/nixos;
    packages = import ./outputs/packages.nix {inherit inputs;};
  in {
    inherit nixosModules packages;
    # Pass along the references so that self is not needed to be called and doesn't break if it's changed
    nixosConfigurations = import ./outputs/nixosConfigurations.nix {inherit inputs nixosModules packages;};
    devShells = import ./outputs/devShells.nix {inherit inputs;};
  };

  # I use some alternative fetchers to get some sources
  # Npins for git repos
  # Nvfetchers for appImages
  inputs = {
    # This downloads Nixpkgs directly from the NixOS Foundation Hydra instance
    # It does properly lock and my main reason is to avoid github as a source
    # since lately there has been a good amount of availability issues
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nix-darwin.follows = "";
        nixpkgs.follows = "";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    rootbeer = {
      url = "github:michael-c-buckley/rootbeer";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    disko-zfs = {
      url = "github:numtide/disko-zfs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        disko.follows = ""; # This works because I manually import Disko via npins
        flake-parts.follows = "flake-parts";
      };
    };
  };
}
