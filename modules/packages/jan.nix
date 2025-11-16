# Modified from nixpkgs since too stale, but bumped individually to not have to maintain
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ja/jan/package.nix
{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    source = (pkgs.callPackage "${self}/_sources/generated.nix" {}).jan;
    appimageContents = pkgs.appimageTools.extractType2 source;
    inherit (source) pname version src;
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
        maintainers = []; # Not it!
        platforms = with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64;
      };
    };
  };
}
