{
  description = "Michael's system flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rush = {
      url = "github:michael-c-buckley/rush/nix-update";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "";
      };
    };
  };

  outputs =
    { self, ... }@inputs:
    {
      devShells = import ./outputs/devShells.nix { inherit self inputs; };
      packages = import ./outputs/packages.nix { inherit self inputs; };
      nixosConfigurations = import ./outputs/nixosConfigurations.nix { inherit self inputs; };
    };
}
