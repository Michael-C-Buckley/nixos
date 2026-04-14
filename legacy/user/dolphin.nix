{
  flake.custom.hjemConfigs.dolphin = {
    config,
    pkgs,
    ...
  }: {
    hjem.users.${config.custom.hjem.username} = {
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
