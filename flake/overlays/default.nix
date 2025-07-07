inputs: _: super: let
  mkPkg = dir: super.callPackage ../packages/${dir} {inherit inputs;};
in {
  nvf = mkPkg "nvf/packages/default.nix";
  nvf-minimal = mkPkg "nvf/packages/minimal.nix";
}
