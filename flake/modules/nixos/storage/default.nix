{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./disko
    ./impermanence
    ./gluster.nix
    # ./nfs.nix
    ./zfs.nix
  ];

  options.system.boot.uuid = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The UUID of the /boot partition.";
  };

  config.fileSystems."/boot" = lib.mkIf (config.system.boot.uuid != null) {
    device = "/dev/disk/by-uuid/${config.system.boot.uuid}";
    fsType = "vfat";
  };

  # Add gluster module
}
