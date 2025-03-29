{
  description = "Michael's System Flake";

  # TO-DO: Adjust follows
  inputs = {
    # Following Cosmic to maximize Cachix hits and reduce duplication
    nixpkgs.follows = "cosmic/nixpkgs";
    lix.url = "git+https://git.lix.systems/lix-project/lix";
    nix-secrets.url = "git+ssh://git@github.com/Michael-C-Buckley/nix-secrets";

    # User configs
    home-manager.url = "github:nix-community/home-manager";
    hjem.url = "github:feel-co/hjem";
    
    # Externally Cached
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    hyprland.url = "github:hyprwm/hyprland";
    microvm.url = "github:astro/microvm.nix";
    wfetch.url = "github:iynaix/wfetch";

    # Custom Modules
    nixos-modules.url = "github:Michael-C-Buckley/nixos-modules";

    # Utilities
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix.url = "github:e-tho/ucodenix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    ragenix.url = "github:yaxitech/ragenix";
    
  };

  # TO-DO: Add support for ARM
  outputs = {
    self,
    ...
  } @ inputs: let
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
    };
  in {
    checks = (import ./outputs/checks.nix {inherit inputs;});
    devShells.x86_64-linux = (import ./outputs/devshells.nix {inherit self pkgs;});
    homeConfigurations = (import ./outputs/homeConfigs.nix {inherit inputs pkgs;});
    nixosConfigurations = (import ./outputs/hostConfigs.nix {inherit inputs;});
  };
}
