{
  inputs,
  pkgs,
  ...
}: let
  jail = (import "${inputs.self.npins.jail}/lib").init pkgs;
in {
  # Main body of the jailed binary
  librewolf = let
    jailed = jail "librewolf-jail" pkgs.librewolf (with jail.combinators; [
      network
      gui
      gpu
      (set-env "DCONF_PROFILE" "/dev/null")
      (readonly "/run/current-system/sw/lib/locale/locale-archive")
      (rw-bind (noescape "~/Downloads/") (noescape "~/Downloads/"))
      (dbus {
        talk = [
          # Generally safe items to add, however you should investigate them if you want to
          # ensure your environment is protected
          "org.a11y.Bus"
          "org.freedesktop.Notifications"
          "org.freedesktop.FileManager1"
          "org.freedesktop.portal.Desktop"
          "org.freedesktop.portal.FileChooser"
          "org.freedesktop.portal.OpenURI"
          "org.freedesktop.portal.Inhibit"
        ];
      })
    ]);
    # Patch librewolf's desktop for this one
    patchDesktopFile = pkgs.runCommand "librewolf-jailed-desktop" {} ''
      mkdir -p $out/share/{applications,icons}
      cp  -r ${pkgs.librewolf}/share/icons $out/share
      sed 's|Exec=librewolf |Exec=librewolf-jail |g' \
          ${pkgs.librewolf}/share/applications/librewolf.desktop \
          > $out/share/applications/librewolf.desktop
    '';
  in
    # Combine as the jailed instance will not include one
    pkgs.symlinkJoin {
      name = "librewolf";
      paths = [jailed patchDesktopFile];
    };
}
