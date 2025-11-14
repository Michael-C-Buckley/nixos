{
  description = "Michael's System Flake";

  # I live the majority of things in files matching the name of their flake output type
  outputs = {
    flake-parts,
    import-tree,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # These are the only systems types I support
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        flake-parts.flakeModules.modules
        (import-tree ./modules)
      ];
    };

  inputs = {
    # A slightly smaller tarball delivered from the NixOS Foundation
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz"; # Pinned due to issues

    nix-secrets = {
      url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets?shallow=1";
      inputs = {
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
      };
    };

    # No Nixpkgs Inputs
    import-tree.url = "github:vic/import-tree";
    impermanence.url = "github:nix-community/impermanence";
    flake-parts.url = "github:hercules-ci/flake-parts";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hjem.follows = "hjem";
        ndg.follows = "";
        treefmt-nix.follows = ""; #  I don't need their formatter
      };
    };

    nvf = {
      url = "github:michael-c-buckley/nvf/v0.8";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        quickshell.follows = ""; # I am using the nixpkgs version
      };
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };
  };
}
