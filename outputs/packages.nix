# Helper function to properly import package references in my flake
{inputs}: let
  inherit (import ../lib/flake {inherit inputs;}) eachSystem mkImport systems;
  inherit (inputs.nixpkgs.lib) foldl' recursiveUpdate;
in
  foldl' recursiveUpdate {} [
    (eachSystem systems.mac (mkImport ../packages/mac))
    (eachSystem systems.linux (mkImport ../packages/linux))
    (eachSystem systems.all (mkImport ../packages/all))
  ]
