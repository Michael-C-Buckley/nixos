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
  mkHost =
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
in
builtins.mapAttrs mkHost {
  x570 = { };
  t14.cfgName = "t14g5";
  b550 = { };
  tungsten = { };
}
