{
  description = "Michael's System Flake";

  # I live the majority of things in files matching the name of their flake output type
  outputs = {
    flake-parts,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) hasPrefix lists;
    inherit (nixpkgs.lib.fileset) toList fileFilter;

    # Replacement for import-tree
    # This recursively collects all nix files that do not start with `_`
    mkImport = path: toList (fileFilter (f: f.hasExt "nix" && !(hasPrefix "_" f.name)) path);
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports =
        lists.flatten
        [
          flake-parts.flakeModules.modules
          (mkImport ./modules)
          (mkImport ./packages)
        ];

      # Easy mechanism to make them available everywhere
      flake.npins = import ./npins;
      flake.nvfetcher = ./_sources/generated.nix;

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        # Globally set unfree for all per-system evals
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # The shell is available as either a devshell or traditional nix-shell
        devShells.default = import ./shell.nix {inherit pkgs;};
      };
    };

  # I use some alternative fetchers to get some sources
  # Npins for git repos
  # Nvfetchers for appImages
  inputs = {
    # This downloads Nixpkgs directly from the NixOS Foundation Hydra instance
    # It does properly lock and my main reason is to avoid github as a source
    # since lately there has been a good amount of availability issues
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
        smfh.follows = ""; # Deleted input since I use the nixpkgs version
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
