{
  flake.hjemConfigs.dolphin = {pkgs, ...}: {
    hjem.users.michael = {
      environment.sessionVariables = {
        # These are also in Hyprland since shell environment is not part of
        # the launcher and won't read in properly
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_STYLE_OVERRIDE = "kvantum";
        KDE_PLATFORM_THEME = "qt6ct";
      };

      packages = with pkgs.kdePackages; [
        dolphin
        kservice
        kio
        qt6ct
        qtsvg
        qtstyleplugin-kvantum
      ];

      xdg.mime-apps.added-associations = {
        "inode/directory" = ["org.kde.dolphin.desktop"];
      };
    };
  };
}
