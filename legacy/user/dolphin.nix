{
  flake.hjemConfigs.dolphin = {pkgs, ...}: {
    hjem.users.michael = {
      packages = with pkgs.kdePackages; [
        dolphin
        kservice
        kio
      ];

      xdg.mime-apps.added-associations = {
        "inode/directory" = ["org.kde.dolphin.desktop"];
      };
    };
  };
}
