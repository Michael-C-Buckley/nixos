{
  boot = {
    kernelModules = [ "zfs" ];
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = true;
  };

  services.zfs.autoScrub.enable = true;
}
