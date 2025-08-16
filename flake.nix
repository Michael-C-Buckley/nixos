{
  description = "Michael's System Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nix-secrets = {
      url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "git+https://github.com/hercules-ci/flake-parts?shallow=1";
    systems.url = "git+https://github.com/nix-systems/default?shallow=1";

    nixos-wsl = {
      url = "git+https://github.com/nix-community/nixos-wsl?shallow=1&ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "git+https://github.com/michael-c-buckley/hjem?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem-rum = {
      url = "git+https://github.com/snugnug/hjem-rum?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hjem.follows = "hjem";
      };
    };

    sops-nix = {
      url = "git+https://github.com/Mic92/sops-nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "git+https://github.com/notashelf/nvf?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };

    mangowc = {
      url = "git+https://github.com/DreamMaoMao/mangowc?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # No Nixpkgs Inputs
    lupinix = {
      url = "git+https://github.com/Michael-C-Buckley/lupinix?shallow=1&ref=noDash";
      inputs.flake-parts.follows = "flake-parts";
    };
    impermanence.url = "git+https://github.com/nix-community/impermanence?shallow=1";
    quadlet-nix.url = "git+https://github.com/SEIAROTg/quadlet-nix?shallow=1";
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
