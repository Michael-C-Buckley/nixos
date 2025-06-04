{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nix-secrets.url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets";

    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    lupinix.url = "github:Michael-C-Buckley/lupinix/noDash";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm.url = "github:astro/microvm.nix";
    sops-nix.url = "github:Mic92/sops-nix";

    impermanence.url = "github:nix-community/impermanence"; # has no inputs
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
