# Add local packages
{self, inputs}: _: super: {
  nvf = super.callPackage ../packages/nvf/packages/default.nix {inherit self inputs;};
  nvf-default = super.callPackage ../packages/nvf/packages/default.nix {inherit self inputs;};
  nvf-minimal = super.callPackage ../packages/nvf/packages/minimal.nix {inherit self inputs;};
}
