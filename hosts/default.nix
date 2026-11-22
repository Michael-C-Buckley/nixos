{
  self,
  inputs,
  configPaths,
}:
let
  system = "x86_64-linux";
  hostImports = import ../modules/nixos/host-imports.nix;
  mkHost =
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
in
builtins.mapAttrs mkHost {
  x570 = ./x570/config.nix;
  t14 = ./t14g5/config.nix;
  b550 = ./b550/config.nix;
  tungsten = ./tungsten/config.nix;
}
