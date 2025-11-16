# Modified from nixpkgs since too stale, but bumped individually to not have to maintain
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ja/jan/package.nix
{
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    pname = "Jan";
    version = "0.7.3";
    src = pkgs.fetchurl {
      url = "https://github.com/janhq/jan/releases/download/v${version}/jan_${version}_amd64.AppImage";
      hash = "sha256-HU6oOWgXz8ssD6PVNAd2n/7urpc0ppQQT518hF4mt1c=";
    };

    appimageContents = pkgs.appimageTools.extractType2 {inherit pname version src;};
  in {
    packages.jan = pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
        cp -r ${appimageContents}/usr/share/icons $out/share
      '';

      meta = {
        changelog = "https://github.com/menloresearch/jan/releases/tag/v${version}";
        description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
        homepage = "https://github.com/menloresearch/jan";
        license = lib.licenses.agpl3Plus;
        mainProgram = "Jan";
        maintainers = [];
        platforms = with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64;
      };
    };
  };
}
