{
  perSystem = {pkgs, ...}: let
    pname = "helium";
    version = "0.6.3.1";

    src = pkgs.fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-x86_64.AppImage";
      hash = "sha256-N7JpLLOdsnYuzYreN1iaHI992MR2SuXTmXHfa6fd1UU=";
    };

    contents = pkgs.appimageTools.extract {inherit pname version src;};
  in {
    packages.helium = pkgs.appimageTools.wrapType2 {
      inherit pname src version;

      extraInstallCommands = ''
        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';
    };
  };
}
