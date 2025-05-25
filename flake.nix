{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
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
    microvm.url = "github:astro/microvm.nix";

    # Utilities
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    ucodenix.url = "github:e-tho/ucodenix";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:Michael-C-Buckley/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    nvf.url = "github:notashelf/nvf";
    nil.follows = "nvf/nil";
  };

  outputs = {self, ...} @ inputs: let 
    overlays = [
      (import ./overlays/localPkgs.nix {inherit self;})
      inputs.nix4vscode.overlays.forVscode
    ];
    cfgVars = {inherit self overlays;};
  in {
    checks = import ./outputs/checks.nix {inherit inputs;};
    devShells = import ./outputs/devshells.nix {inherit self;};
    homeConfigurations = import ./configurations/homeConfigs.nix cfgVars;
    nixosConfigurations = (
      import ./configurations/hostConfigs.nix cfgVars
      // import ./configurations/clusterConfigs.nix cfgVars
    );
    nixosModules = import ./modules/nixosModules.nix {};
    # overlays = import ./overlays {inherit self;};
    packages = import ./packages {inherit self;};
    userModules = import ./modules/userModules.nix;
  };
}
