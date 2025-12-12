{
  description = "Michael's System Flake";

  # I live the majority of things in files matching the name of their flake output type
  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # These are the only systems types I support
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use a separately pinned input to prevent unnecessary custom kernel rebuilds
    kernel-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No Nixpkgs Inputs
    import-tree.url = "github:vic/import-tree";
    impermanence.url = "github:nix-community/impermanence";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem/refactor-3"; # Hjem-Darwnin testing
      inputs = {
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
        smfh.follows = ""; # Use nixpkgs version
      };
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hjem.follows = "hjem";
        ndg.follows = "";
        treefmt-nix.follows = ""; #  I don't need their formatter
      };
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        ndg.follows = ""; # Documentation generator
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
