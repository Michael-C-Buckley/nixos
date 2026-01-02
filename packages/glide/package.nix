{
  perSystem = {pkgs, ...}: {packages.glide = pkgs.callPackage ./_derivation.nix {};};
}
