{
  description = "Michael's System Flake";

  inputs = {
    # Following Cosmic to maximize Cachix hits and reduce duplication
    nixpkgs.follows = "cosmic/nixpkgs";
    nix-secrets.url = "git+ssh://git@github.com/Michael-C-Buckley/nix-secrets";

    # User configs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Externally Cached
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    hyprland.url = "github:hyprwm/hyprland";
    microvm.url = "github:astro/microvm.nix";
    wfetch.url = "github:iynaix/wfetch";
    # Lix has a cache but it has few entries and will likely miss
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utilities
    ucodenix.url = "github:e-tho/ucodenix";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TO-DO: Add support for ARM
  outputs = {self, ...} @ inputs: let
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
    };
    lib = pkgs.lib;
    customLib = import ./lib { inherit lib pkgs; };
  in {
    checks = import ./outputs/checks.nix {inherit inputs;};
    devShells.x86_64-linux = import ./outputs/devshells.nix {inherit self pkgs;};
    homeConfigurations = import ./outputs/homeConfigs.nix {inherit inputs pkgs;};
    nixosConfigurations = (
      import ./outputs/hostConfigs.nix {inherit inputs customLib;}
      // import ./outputs/clusterConfigs.nix {inherit inputs customLib;}
    );
    nixosModules = import ./outputs/nixosModules.nix {};
  };
}
