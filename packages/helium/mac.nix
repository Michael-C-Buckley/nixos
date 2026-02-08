{config, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    source = (pkgs.callPackage config.flake.nvfetcher {}).helium-mac;
  in
    lib.optionalAttrs (lib.hasSuffix system "darwin") {
      packages.helium = pkgs.stdenve.mkDerivation {
        inherit (source) pname version src;

        nativeBuildInputs = [pkgs.undmg];
        sourceRoot = ".";

        installPahse = ''
          mkdir -p $out/Applications
          cp -r Helium.app $out/Applications/
        '';
      };
    };
}
