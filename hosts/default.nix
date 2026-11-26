{
  self,
  inputs,
  configPaths,
  nixosModules,
  hjemModules,
  ...
}:
let
  system = "x86_64-linux";
  hostImports = import ../modules/nixos/host-imports.nix;
  mkNixosHost =
    hostname:
    {
      modules ? [ ],
      cfgName ? hostname,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      pkgs = self.legacyPackages.${system};
      specialArgs = {
        inherit
          inputs
          configPaths
          nixosModules
          hjemModules
          ;
      };
      modules =
        hostImports.${hostname}
        ++ [
          (./. + "/${cfgName}/config.nix")
          {
            networking.hostName = hostname;
            hjem.users.michael.imports = [
              ../modules/hjem/presets/base-common.nix
              ../modules/hjem/michael.nix
            ];
          }
        ]
        ++ modules;
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
  x570 = { };
  t14.cfgName = "t14g5";
  b550 = { };
  tungsten = { };
}
// builtins.mapAttrs mkFinixHost {
  t14f = ./t14g5/finix/config.nix;
  finix = ./finix/config.nix;
  finix-vm = ./finix-vm/config.nix;
}
