# Add local packages
self: super: {
  nvf = super.callPackage ../packages/nvf/packages/default.nix {};
  nvf-minimal = super.callPackage ../packages/nvf/packages/minimal.nix {}
}
