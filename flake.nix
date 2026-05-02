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

    npins = import ./npins;

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
      flake = {
        inherit npins;
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args = {
          # Nvfetcher is only used for packaging so pass it as a module arg
          nvfetcher = ./_sources/generated.nix;
          # Globally set unfree for all per-system evals
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nix-darwin.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
