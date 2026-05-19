{
  description = "Michael's System Flake";

  outputs = inputs: let
    inherit (import ./lib/flake {inherit inputs;}) mkModule;
  in {
    nixosConfigurations = import ./outputs/nixosConfigurations.nix {inherit inputs;};
    nixosModules = mkModule ./modules/nixos;
    packages = import ./outputs/packages.nix {inherit inputs;};
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
        disko.follows = "disko";
      };
    };
  };
}
