{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nix-secrets.url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets?shallow=1";

    flake-parts.url = "git+https://github.com/hercules-ci/flake-parts?shallow=1";
    systems.url = "github:nix-systems/default";

    nixos-wsl = {
      url = "git+https://github.com/nix-community/nixos-wsl?shallow=1&ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "git+https://github.com/nix-community/home-manager?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:Michael-C-Buckley/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hjem.follows = "hjem";
      };
    };

    microvm.url = "git+https://github.com/astro/microvm.nix?shallow=1";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "git+https://github.com/notashelf/nvf?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil.follows = "nvf/nil";

    nix4vscode = {
      url = "git+https://github.com/nix-community/nix4vscode?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "git+https://github.com/nix-community/nix-vscode-extensions?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No Nixpkgs Inputs
    lupinix.url = "github:Michael-C-Buckley/lupinix/noDash";
    impermanence.url = "github:nix-community/impermanence"; # has no inputs
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      imports = with inputs;
        [lupinix.flakeModules.default]
        ++ import ./flake/modules-list.nix;

      debug = true;

      perSystem = {system, ...}: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {allowUnfree = true;};
          overlays = with inputs; [
            nix4vscode.overlays.forVscode
            nix-vscode-extensions.overlays.default
          ];
        };
      };
    };
}
