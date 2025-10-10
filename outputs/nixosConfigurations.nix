{inputs, ...}: let
  inherit (builtins) mapAttrs;
  inherit (inputs) self nixpkgs import-tree quadlet-nix;

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
    hostPath ? ../systems,
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
          (import-tree "${hostPath}/${hostname}")
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
      };
      p520 = {hjem = "server";};
      t14 = {};
      tempest = {secrets = "common";};
      x570 = {
        modules = [quadlet-nix.nixosModules.quadlet];
      };
    };
}
