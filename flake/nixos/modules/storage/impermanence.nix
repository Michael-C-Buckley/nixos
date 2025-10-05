# Mostly default example from Impermanence
#
# Differences in mounts:
# - Persist: persisted and ZFS snapshotted
# - Cache: persisted but no snapshots
{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (config.system) impermanence;

  sanoidDefaults = {
    autoprune = true;
    autosnap = true;
    hourly = 12;
    daily = 3;
    weekly = 2;
    monthly = 2;
  };
in
  lib.mkIf impermanence.enable {
    # To make sure keys are available for sops decryption
    fileSystems."/etc/ssh".neededForBoot = true;

    environment.persistence."/cache" = {
      hideMounts = true;
      directories = [
        # A generic bind for caching
        "/var/lib/cache"

        "/var/lib/nixos-containers"
        "/var/lib/machines"
        "/var/lib/containerd"
        "/home/michael/.cache"
        "/home/michael/Downloads"
        "/home/shawn/.cache"
        "/home/shawn/Downloads"
      ];
    };
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/ssh"
        "/etc/nixos"
        "/etc/sops"
        "/etc/NetworkManager"
        "/etc/nix"
        "/etc/wireguard"

        # A generic bind for persisting
        "/var/lib/persist"

        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd"

        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        "/etc/machine-id"
      ];
    };

    services.sanoid = {
      inherit (config.system.zfs) enable;

      datasets = {
        "zroot/${hostName}/nixos/persist" = sanoidDefaults;
      };
    };
  }
