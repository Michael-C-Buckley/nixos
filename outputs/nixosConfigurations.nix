{inputs, ...}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) self nixpkgs import-tree;

  customLib = import ../flake/lib {inherit (nixpkgs) lib;};

  defaultMods = [
    self.hjemConfigurations.root
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
  ];

  mkSystem = {
    hostname,
    system ? "x86_64-linux",
    modules ? [],
    hjem ? "default",
    secrets ? hostname,
  }: let
    # Wrapper to shim the output packages so they can be plumbed more easily elsewhere
    customPkgs = self.packages.${system};
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      # Special args are a better mechanism than overlays because it is significantly more
      #  obvious what came from where without indirection
      specialArgs = {inherit self inputs customLib customPkgs;};

      modules =
        modules
        ++ defaultMods
        ++ [
          self.hjemConfigurations.${hjem}
          inputs.nix-secrets.nixosModules.${secrets}
        ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
in {
  flake.nixosConfigurations =
    # Add the hostname to the params
    mapAttrs (
      hostname: params:
        mkSystem (params // {inherit hostname;})
    ) {
      o1 = {
        system = "aarch64-linux";
        hjem = "minimal-arm";
        modules = [(import-tree ../systems/o1)];
      };
      p520 = {
        hjem = "server";
        modules = [(import-tree ../systems/p520)];
      };
      t14 = {modules = [(import-tree ../systems/t14)];};
      tempest = {
        secrets = "common";
        modules = [(import-tree ../systems/tempest)];
      };

      x570 = {
        modules = [self.modules.nixos.x570];
      };
    };
}
