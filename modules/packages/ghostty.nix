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

      unpackPhase = ''
        undmg "$src" || 7zz x -snld "$src"
      '';

      installPhase = ''
        mkdir -p $out/Applications
        cp -r Ghostty.app $out/Applications/

        mkdir -p $out/bin
        makeWrapper $out/Applications/Ghostty.app/Contents/MacOS/ghostty $out/bin/ghostty-dmg
      '';

      nativeBuildInputs = with pkgs; [
        _7zz
        makeWrapper
        undmg
      ];

      sourceRoot = ".";
    };
  };
}
