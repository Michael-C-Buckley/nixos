{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-secrets = {
      url = "git+ssh://git@github.com/Michael-C-Buckley/nix-secrets";
      inputs.nixos.follows = ""; # Ignore because it inputs this flake
    };

    # User configs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    michael-nvf = {
      url = "github:Michael-C-Buckley/nvf-flake";
    };

    # Externally Cached
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    microvm.url = "github:astro/microvm.nix";

    # Utilities
    impermanence.url = "github:nix-community/impermanence";
    ucodenix.url = "github:e-tho/ucodenix";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

    # Applications
    nvf.url = "github:notashelf/nvf";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ...
  };

  outputs = {self, ...} @ inputs: {
    checks = import ./outputs/checks.nix {inherit inputs;};
    devShells = import ./outputs/devshells.nix {inherit self;};
    homeConfigurations = import ./outputs/homeConfigs.nix {inherit self;};
    nixosConfigurations = (
      import ./outputs/hostConfigs.nix {inherit self;}
      // import ./outputs/clusterConfigs.nix {inherit self;}
    );
    nixosModules = import ./outputs/nixosModules.nix {};
    packages = import ./outputs/packages.nix {inherit self;};
  };
}
