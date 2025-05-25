# Add local packages
_: _: super: {
  nvf = super.callPackage ../packages/nvf/packages/default.nix {};
  nvf-minimal = super.callPackage ../packages/nvf/packages/minimal.nix {};
}
