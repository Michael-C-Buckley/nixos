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
        ./packages
      ];
    };

  inputs = {
    # A slightly smaller tarball delivered from the NixOS Foundation
    #  Locks and works as it should
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    # No Nixpkgs Inputs
    nix-secrets.url = "git+ssh://git@github.com/michael-c-buckley/nix-secrets";
    import-tree.url = "github:vic/import-tree";
    impermanence.url = "github:nix-community/impermanence";
    flake-parts.url = "github:hercules-ci/flake-parts";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    hjem = {
      url = "github:feel-co/hjem/31f969f69f02b62e417bcc39571a605977cb89fa"; # Pinned due to linking issue
      inputs = {
        nixpkgs.follows = "nixpkgs";
        ndg.follows = ""; # This is for their docs generator
        smfh.follows = ""; # I use the nixpkgs version
      };
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hjem.follows = "hjem";
        ndg.follows = "";
      };
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      # An update broke my config
      url = "github:notashelf/nvf/ea3ee477fa1814352b30d114f31bf4895eed053e";
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

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
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
