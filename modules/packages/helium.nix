{self, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    source = (pkgs.callPackage "${self}/_sources/generated.nix" {}).helium;
    contents = pkgs.appimageTools.extract source;
    inherit (source) pname version src;
  in
    lib.optionalAttrs (!lib.hasSuffix "darwin" system) {
      packages.helium = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        extraInstallCommands = ''
          install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          cp -r ${contents}/usr/share/icons $out/share
        '';
      };
    };
}
