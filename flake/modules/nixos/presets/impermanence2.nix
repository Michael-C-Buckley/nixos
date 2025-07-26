# The second generation of preset for my ZFS+Impermanence
#  Users no longer have impermanence
#  Datasets broken up with greater granularity
#  Local datasets are not meant to be replicate off-device
{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (lib) mkEnableOption mkIf;
  inherit (config.system) impermanence;

  mkZfs = path: {
    device = "zroot/${path}";
    fsType = "zfs";
    neededForBoot = true;
  };
in {
  options.system.impermanence = {
    usePreset2 = mkEnableOption "Configures the new impermanence preset rules.";
  };

  config = mkIf (impermanence.enable && impermanence.usePreset2) {
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

      # New local datasets
      "/cache" = mkZfs "local/cache";
      "/nix" = mkZfs "local/nix";
      "/crypt" = mkZfs "local/crypt";

      # ZFS Volumes
      "/persist" = mkZfs "${hostName}nixos/persist";

      # Home
      "/home/michael" = mkZfs "home/michael";
      "/home/shawn" = mkZfs "home/shawn";
    };
  };
}
