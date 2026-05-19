# Helper function to properly import package references in my flake
{inputs}: let
  eachSystem = import ./eachSystem.nix {inherit inputs;};
  mac = ["aarch64-darwin"];
  linux = ["aarch64-linux" "x86_64-linux"];
  all = mac ++ linux;
  inherit (inputs.nixpkgs.lib) foldl' recursiveUpdate;
in
  foldl' recursiveUpdate {} [
    (eachSystem mac ../packages/mac)
    (eachSystem linux ../packages/linux)
    (eachSystem all ../packages/all)
  ]
