{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nix-secrets = {
      url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "git+https://github.com/hercules-ci/flake-parts?shallow=1";
    systems.url = "github:nix-systems/default";

    nixos-wsl = {
      url = "git+https://github.com/nix-community/nixos-wsl?shallow=1&ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "git+https://github.com/nix-community/home-manager?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "git+https://github.com/Michael-C-Buckley/hjem?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem-rum = {
      url = "git+https://github.com/snugnug/hjem-rum?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hjem.follows = "hjem";
      };
    };

    microvm.url = "git+https://github.com/astro/microvm.nix?shallow=1";
    sops-nix = {
      url = "git+https://github.com/Mic92/sops-nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "git+https://github.com/notashelf/nvf?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No Nixpkgs Inputs
    lupinix.url = "git+https://github.com/Michael-C-Buckley/lupinix?shallow=1&ref=noDash";
    impermanence.url = "git+https://github.com/nix-community/impermanence?shallow=1"; # has no inputs
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
          overlays = [(import ./flake/overlays inputs)];
        };
      };
    };
}
