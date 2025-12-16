# Helium Browser, pulled from the appImage and jailed
{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    # Preparation definitions on various tooling
    source = (pkgs.callPackage ../_sources/generated.nix {}).helium;
    contents = pkgs.appimageTools.extract source;
    inherit (source) pname version src;

    jail = inputs.jail.lib.init pkgs;
    homeBind = with jail.combinators; path: (rw-bind (noescape path) (noescape path));

    features = with jail.combinators;
      [
        network
        gui
        (readonly "/nix/store")
        (dbus {
          talk = [
            "org.freedesktop.portal.*"
            "org.freedesktop.Notifications"
            "org.freedesktop.FileManager1"
          ];
        })
      ]
      ++ [
        (homeBind "~/.local/share/applications/")
        (homeBind "~/Downloads")
        (homeBind "~/.cache/net.imput.helium/")
        (homeBind "~/.config/net.imput.helium/")
      ];

    extraInstallCommands = ''
      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

    localPkg = pkgs.appimageTools.wrapType2 {
      inherit pname version src extraInstallCommands;
    };
  in
    # Helium is only available on linux and bwrap is a linux only utility
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages = {
        helium = localPkg;
        helium-jailed = jail "helium" localPkg features;
      };
    };
}
