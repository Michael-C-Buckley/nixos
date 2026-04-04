{config, ...}: let
  inherit (config) flake;
  zfsUnits = config.flake.custom.lib.mkJournalNamespace "zfs" [
    "zfs-mount"
    "zfs-share"
    "zfs-zed"
    "zfs-import"
    "zfs-scrub"
    "sanoid"
    "syncoid"
  ];
in {
  flake.modules.nixos.zfs = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config.custom.journald) zfs;
  in {
    options.custom.journald.zfs = flake.custom.lib.mkJournalOptions;

    config = {
      boot = {
        kernelModules = ["zfs"];
        supportedFilesystems = ["zfs"];
        zfs.package = lib.mkDefault pkgs.zfs_2_4;
      };

      # Add custom namespace for ZFS logs
      environment.etc."systemd/journald@zfs.conf".text = flake.custom.lib.mkJournalEtcFile zfs;

      services.zfs.autoScrub.enable = true;

      systemd.services =
        {
          # https://github.com/openzfs/zfs/issues/10891
          systemd-udev-settle.enable = false;
          # Add to persistent journaling
        }
        // zfsUnits;

      services.sanoid = {
        enable = true;
        templates = {
          short = {
            autoprune = true;
            autosnap = true;
            hourly = 6;
            daily = 1;
          };
          normal = {
            autoprune = true;
            autosnap = true;
            hourly = 12;
            daily = 3;
            weekly = 2;
            monthly = 2;
          };
          database = {
            autoprune = true;
            autosnap = true;
            hourly = 50;
            daily = 10;
            weekly = 4;
            monthly = 6;
          };
        };
      };
    };
  };
}
