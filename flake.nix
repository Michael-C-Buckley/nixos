{
  description = "Michael's System Flake";

  inputs = {
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
    microvm.url = "github:astro/microvm.nix";
    sops-nix.url = "github:Mic92/sops-nix";

    # Utilities
    impermanence.url = "github:nix-community/impermanence"; # has no inputs
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    nvf.url = "github:notashelf/nvf";
    nil.follows = "nvf/nil";

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    overlays = [
      (import ./overlays/localPkgs.nix {inherit self inputs;})
      inputs.nix4vscode.overlays.forVscode
      inputs.nix-vscode-extensions.overlays.default
    ];
    cfgVars = {inherit self overlays;};
  in {
    devShells = import ./outputs/devshells.nix {inherit self;};
    homeConfigurations = import ./configurations/homeConfigs.nix cfgVars;
    nixosConfigurations =
      import ./configurations/hostConfigs.nix cfgVars
      // import ./configurations/clusterConfigs.nix cfgVars;
    nixosModules = import ./modules/nixosModules.nix {};
    # overlays = import ./overlays {inherit self;};
    packages = import ./packages {inherit self;};
    userModules = import ./modules/userModules.nix;
  };
}
