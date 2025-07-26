# I use this as my starting point for the root filesystem for Impermanence with ZFS
{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) str bool;
  inherit (config.system) impermanence;

  nixPkg = config.nix.package;

  zfsFs = name: {
    device = "${impermanence.zrootPath}/${name}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  options.system.impermanence = {
    usePreset = mkOption {
      type = bool;
      default = true;
      description = "Configures the impermanence preset rules.";
    };
    # WIP: De-nest 1 level
    zrootPath = mkOption {
      type = str;
      default = "zroot/${hostName}";
      description = "The ZFS dataset path for the root filesystem.";
    };
    tmpRootSize = mkOption {
      type = str;
      default = "1G";
      description = "The size of the tmpfs root partition.";
    };
    useTmpDataset = mkEnableOption "Create a separate dataset for `\tmp`. Optional after Nix 2.30, where it builds in `\nix` instead of `\tmp`.";
  };

  config = mkIf (impermanence.enable && impermanence.usePreset) {
    system.zfs.enable = true;

    fileSystems = {
      # Tmpfs
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=${impermanence.tmpRootSize}"
          "mode=755"
        ];
      };

      # ZFS Volumes
      "/nix" = zfsFs "nix";
      "/cache" = zfsFs "cache";
      "/persist" = zfsFs "persist";

      # Use a Tmp dataset for nix builds
      # Lix guard statement since it follows older Nix behavior
      "/tmp" = mkIf (impermanence.useTmpDataset || nixPkg.pname == "lix") (zfsFs "tmp");
    };
  };
}
