{
  description = "Michael's System Flake";

  inputs = {
    # Following Cosmic to maximize Cachix hits and reduce duplication
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "cosmic/nixpkgs";
    nixpkgs-stable.follows = "cosmic/nixpkgs-stable";
    lix.url = "git+https://git.lix.systems/lix-project/lix";

    # User configs
    michael-home = {
      url = "github:Michael-C-Buckley/home-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "";
    };
    hyprland.url = "github:hyprwm/hyprland";
    hjem.follows = "michael-home/hjem";
    wfetch.url = "github:iynaix/wfetch";

    # Custom Modules
    nix-secrets.url = "git+ssh://git@github.com/Michael-C-Buckley/nix-secrets";
    nixos-modules.url = "github:Michael-C-Buckley/nixos-modules";

    # Utilities
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix.url = "github:e-tho/ucodenix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    ragenix.url = "github:yaxitech/ragenix";
    microvm.url = "github:astro/microvm.nix";
  };

  outputs = {
    self,
    ...
  } @ inputs: {
    checks = (import ./outputs/checks.nix {inherit inputs;});
    devShells.x86_64-linux = (import ./outputs/devshells.nix {inherit self;});
    nixosConfigurations = (import ./outputs/hostConfigs.nix {inherit inputs;});
  };
}
