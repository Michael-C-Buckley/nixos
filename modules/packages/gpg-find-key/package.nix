{
  perSystem = {pkgs, ...}: {
    packages.gpg-find-key = pkgs.callPackage ./_derivation.nix {};
  };
}
