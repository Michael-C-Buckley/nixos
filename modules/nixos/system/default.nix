{
  flake.modules.nixosModules.system = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.system.boot.uuid = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The UUID of the /boot partition.";
    };

    config = {
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_16;
      time.timeZone = "America/New_York";
      environment.enableAllTerminfo = true;

      fileSystems."/boot" = lib.mkIf (config.system.boot.uuid != null) {
        device = "/dev/disk/by-uuid/${config.system.boot.uuid}";
        fsType = "vfat";
      };
    };
  };
}
