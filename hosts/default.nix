{
  self,
  inputs,
  configPaths,
}:
let
  system = "x86_64-linux";
  hostImports = import ../modules/nixos/host-imports.nix;
  mkNixosHost =
    hostname: entry:
    inputs.nixpkgs.lib.nixosSystem {
      pkgs = self.legacyPackages.${system};
      specialArgs = { inherit inputs configPaths; };
      modules = hostImports.${hostname} ++ [
        entry
        {
          networking.hostName = hostname;
          hjem.users.michael.imports = [
            ../modules/hjem/presets/base-common.nix
            ../modules/hjem/michael.nix
          ];
        }
      ];
    };
  mkFinixHost =
    hostname: entry:
    inputs.finix.lib.finixSystem {
      inherit (inputs.nixpkgs) lib;
      specialArgs = { inherit inputs configPaths; };
      modules = [
        entry
        {
          networking.hostName = hostname;
          nixpkgs.pkgs = self.legacyPackages.${system};
        }
      ];
    };
in
builtins.mapAttrs mkNixosHost {
  x570 = ./x570/config.nix;
  t14 = ./t14g5/config.nix;
  b550 = ./b550/config.nix;
  tungsten = ./tungsten/config.nix;
}
// builtins.mapAttrs mkFinixHost {
  t14f = ./t14g5/finix/config.nix;
  finix = ./finix/config.nix;
  finix-vm = ./finix-vm/config.nix;
}
