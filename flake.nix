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
        devShells.default = import ./shell.nix {
          inherit pkgs;
          extraPkgs = [self'.packages.opencode];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use a separately pinned input to prevent unnecessary custom kernel rebuilds - pinned against unstable-small
    kernel-nixpkgs.url = "github:NixOS/nixpkgs/fc2de1563f89f0843eba27f14576d261df0e3b80";

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
      url = "github:feel-co/hjem/refactor-3"; # Hjem-Darwnin testing
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
