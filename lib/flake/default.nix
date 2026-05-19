{inputs}: let
  mac = ["aarch64-darwin"];
  linux = ["aarch64-linux" "x86_64-linux"];
  all = mac ++ linux;
in {
  mkImport = import ./mkImport.nix {inherit inputs;};
  mkModule = import ./mkModule.nix {inherit inputs;};
  eachSystem = import ./eachSystem.nix {inherit inputs;};

  # Quick references to my systems
  systems = {
    inherit all mac linux;
  };
}
