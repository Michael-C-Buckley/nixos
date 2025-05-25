# Add local packages
{self, inputs}: _: super: let
  nvfPath = "${self}/packages/nvf/packages";
in {
  nvf = super.callPackage "${nvfPath}/default.nix" {inherit self inputs;};
  nvf-default = super.callPackage "${nvfPath}/default.nix" {inherit self inputs;};
  nvf-minimal = super.callPackage "${nvfPath}/minimal.nix" {inherit self inputs;};
}
