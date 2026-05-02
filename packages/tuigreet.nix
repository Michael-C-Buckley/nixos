# This takes the binary from Raf's releases section and makes a derivation out of it
{
  perSystem = {
    pkgs,
    nvfetcher,
    ...
  }: let
    source = (pkgs.callPackage nvfetcher {}).tuigreet;
    runtimeLibPath = pkgs.lib.makeLibraryPath (
      with pkgs; [
        glibc
        (lib.getLib stdenv.cc.cc)
      ]
    );
  in {
    packages.tuigreet = pkgs.stdenv.mkDerivation {
      inherit (source) pname version src;
      name = "tuigreet";

      dontBuild = true;
      dontConfigure = true;
      dontUnpack = true;
      dontCheck = true;

      installPhase = ''
        install -Dm755 $src $out/bin/tuigreet
        patchelf --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} \
          --set-rpath ${runtimeLibPath} \
          $out/bin/tuigreet
      '';
    };
  };
}
