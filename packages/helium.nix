# Helium Browser, pulled from the appImage and jailed
{config, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    nvfetcher,
    ...
  }: let
    # Preparation definitions on various tooling
    source = (pkgs.callPackage nvfetcher {}).helium;
    contents = pkgs.appimageTools.extract source;
    inherit (source) pname version src;

    jail = (import "${config.flake.npins.jail}/lib").init pkgs;
    homeBind = with jail.combinators; bindPath: (rw-bind (noescape bindPath) (noescape bindPath));

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

    localPkg = pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      nativeBuildInputs = [pkgs.makeWrapper];

      extraInstallCommands = ''
        wrapProgram $out/bin/${pname} \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set-default XDG_DATA_HOME "$HOME/.local/share" \
          --set FONTCONFIG_FILE ${pkgs.makeFontsConf {
          fontDirectories = with pkgs; [
            roboto
            vista-fonts
            noto-fonts
            noto-fonts-cjk-sans
          ];
        }}

        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';

      extraBwrapArgs = [
        # chromium policies
        "--ro-bind-try /etc/chromium/policies/managed/default.json /etc/chromium/policies/managed/default.json"
        # xdg scheme-handlers
        "--ro-bind-try /etc/xdg/ /etc/xdg/"
      ];
    };
  in
    # I currently am only preparing and using this on X86 Linux machines
    lib.optionalAttrs (system == "x86_64-linux") {
      packages = {
        helium = localPkg;
        # Jail version is experimental, as double bwrap causes some issues like with audio
        helium-jailed = jail "helium" localPkg features;
      };
    };
}
