{
  description = "Michael's System Flake";

  # I live the majority of things in files matching the name of their flake output type
  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # These are the only systems types I support
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [./outputs];
    };

  inputs = {
    # A slightly smaller tarball delivered from the NixOS Foundation
    #  Locks and works as it should
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nix-secrets = {
      url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:/feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schizofox = {
      url = "github:schizofox/schizofox";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # No Nixpkgs Inputs
    impermanence.url = "github:nix-community/impermanence";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };
}
