{
  description = "Michael's System Flake";

  inputs = {
    # This might be insane but I have to try it
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
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
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    nvf.url = "github:notashelf/nvf";
    # ...
  };

  outputs = {self, ...} @ inputs: {
    checks = import ./outputs/checks.nix {inherit inputs;};
    devShells = import ./outputs/devshells.nix {inherit self;};
    homeConfigurations = import ./configurations/homeConfigs.nix {inherit self;};
    nixosConfigurations = (
      import ./configurations/hostConfigs.nix {inherit self;}
      // import ./configurations/clusterConfigs.nix {inherit self;}
    );
    nixosModules = import ./outputs/nixosModules.nix {};
    packages = import ./outputs/packages.nix {inherit self;};
  };
}
