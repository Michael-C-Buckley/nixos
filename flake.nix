{
  description = "Michael's System Flake";

  # I live the majority of things in files matching the name of their flake output type
  outputs = {flake-parts, ...} @ inputs: let
    inherit (import ./lib/flake {inherit inputs;}) mkModule;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        flake-parts.flakeModules.modules
        flake-parts.flakeModules.touchup
      ];

      flake = {
        nixosConfigurations = import ./outputs/nixosConfigurations.nix {inherit inputs;};
        nixosModules = mkModule ./modules/nixos;
        packages = import ./outputs/packages.nix {inherit inputs;};
        devShells = import ./outputs/devShells.nix {inherit inputs;};
      };

      # I apparently need to tell them I don't use a formatter to not bug out
      touchup.attr.formatter.enable = false;
    };

  # I use some alternative fetchers to get some sources
  # Npins for git repos
  # Nvfetchers for appImages
  inputs = {
    # This downloads Nixpkgs directly from the NixOS Foundation Hydra instance
    # It does properly lock and my main reason is to avoid github as a source
    # since lately there has been a good amount of availability issues
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nix-darwin.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko-zfs = {
      url = "github:numtide/disko-zfs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        disko.follows = "disko";
      };
    };
  };
}
