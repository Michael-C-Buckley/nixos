# Add Ghostty's official MacOS binary since the nixpkgs source-based version is currently
# broken, this does populate all systems but obviously won't work on Linux
# I may change the logic, if I am less lazy
{self, ...}: {
  perSystem = {pkgs, ...}: let
    source = (pkgs.callPackage "${self}/_sources/generated.nix" {}).ghostty-dmg;
    inherit (source) pname version src;
  in {
    packages.ghostty-dmg = pkgs.stdenv.mkDerivation {
      inherit pname version src;

      installPhase = ''
        mkdir -p $out/Applications
        cp -r Ghostty.app $out/Applications/
      '';

      nativeBuildInputs = [pkgs.undmg];

      sourceRoot = ".";
    };
  };
}
