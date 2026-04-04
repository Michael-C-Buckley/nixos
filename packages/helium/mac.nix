{
  perSystem = {
    pkgs,
    system,
    lib,
    nvfetcher,
    ...
  }: let
    source = (pkgs.callPackage nvfetcher {}).helium-mac;
  in
    lib.optionalAttrs (lib.hasSuffix system "darwin") {
      packages.helium = pkgs.stdenve.mkDerivation {
        inherit (source) pname version src;

        buildInputs = with pkgs; [
          noto-fonts
          dejavu_fonts
        ];

        nativeBuildInputs = [pkgs.undmg];
        sourceRoot = ".";

        installPahse = ''
          mkdir -p $out/Applications
          cp -r Helium.app $out/Applications/
        '';
      };
    };
}
