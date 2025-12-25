{
  description = "Michael's System Flake";

  # I live the majority of things in files matching the name of their flake output type
  outputs = {
    flake-parts,
    nixpkgs,
    ...
  } @ inputs: let
    # Replacement for import-tree
    inherit (nixpkgs.lib.fileset) toList fileFilter;
    mkImport = path:
      toList (fileFilter (file: file.hasExt "nix" && !(nixpkgs.lib.hasPrefix "_" file.name)) path);
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports =
        [
          flake-parts.flakeModules.modules
        ]
        # Currently the function returns a list of the paths per invocation
        ++ (mkImport ./modules) ++ (mkImport ./packages);

      # The shell is available as either a devshell or traditional nix-shell
      perSystem = {
        self',
        pkgs,
        ...
      }: {
        # The devshell includes a jailed opencode instance
        devShells = {
          default = import ./shell.nix {inherit pkgs;};
          opencode = import ./shell.nix {
            inherit pkgs;
            extraPkgs = [self'.packages.opencode];
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No Nixpkgs Inputs
    impermanence.url = "github:nix-community/impermanence";
    flake-parts.url = "github:hercules-ci/flake-parts";
    jail.url = "sourcehut:~alexdavid/jail.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
        smfh.follows = ""; # Use nixpkgs version
      };
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-parts.follows = "flake-parts";
        ndg.follows = ""; # Documentation generator
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
