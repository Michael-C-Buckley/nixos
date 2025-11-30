{
  flake.modules.nixos.zfs = {
    config,
    lib,
    ...
  }: let
    sanoidDefaults = {
      autoprune = true;
      autosnap = true;
      hourly = 12;
      daily = 3;
      weekly = 2;
      monthly = 2;
    };
  in {
    options.custom.zfs.snapshotDatasets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of ZFS datasets to snapshot.";
    };
    config = {
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
      services.sanoid = {
        enable = true;
        # Define some reused templates
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
        };
        datasets = builtins.listToAttrs (map (dataset: {
            name = dataset;
            value = {
              inherit (sanoidDefaults) autoprune autosnap hourly daily weekly monthly;
            };
          })
          config.custom.zfs.snapshotDatasets);
      };
    };
  };
}
