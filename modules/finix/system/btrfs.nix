{
  config,
  lib,
  pkgs,
  ...
}:
let
  supportedFilesystems.btrfs.enable = true;
  cfg = config.services.btrfs.autoScrub;
  btrfsDevices = lib.foldl' (
    acc: fs:
    if fs.fsType != "btrfs" || builtins.elem fs.device (map (other: other.device) acc) then
      acc
    else
      acc ++ [ fs ]
  ) [ ] (builtins.attrValues config.fileSystems);
in
{
  options.services.btrfs.autoScrub = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to scrub Btrfs filesystems periodically.";
    };
    fileSystems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = map (fs: fs.mountPoint) btrfsDevices;
      defaultText = "One mount point per Btrfs device.";
      description = "Mount points to scrub; each device needs only one.";
    };
    interval = lib.mkOption {
      type = lib.types.enum [
        "daily"
        "weekly"
        "monthly"
      ];
      default = "monthly";
      description = "How often to scrub.";
    };
  };

  config = {
    boot = {
      inherit supportedFilesystems;
      initrd = { inherit supportedFilesystems; };
    };
    environment.systemPackages = with pkgs; [
      compsize
      duperemove
    ];
    providers.scheduler.tasks = lib.mkIf cfg.enable (
      lib.listToAttrs (
        map (fs: {
          name =
            "btrfs-scrub-"
            + (if fs == "/" then "root" else lib.replaceStrings [ "/" ] [ "-" ] (lib.removePrefix "/" fs));
          value = {
            inherit (cfg) interval;
            persistent = true;
            randomDelay = true;
            command = "${pkgs.coreutils}/bin/nice -n 19 ${pkgs.util-linux}/bin/ionice -c 3 ${pkgs.btrfs-progs}/bin/btrfs scrub start -B ${lib.escapeShellArg fs}";
          };
        }) cfg.fileSystems
      )
    );
  };
}
