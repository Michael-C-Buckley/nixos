{
  flake.modules.nixos.zfs = {config, ...}: {
    boot = {
      kernelModules = ["zfs"];
      supportedFilesystems = ["zfs"];
    };

    # I don't know if this is necessary, but just in case
    environment.systemPackages = [config.boot.zfs.package];

    services.zfs.autoScrub.enable = true;

    # https://github.com/openzfs/zfs/issues/10891
    systemd.services.systemd-udev-settle.enable = false;

    # Sanoid
  };
}
