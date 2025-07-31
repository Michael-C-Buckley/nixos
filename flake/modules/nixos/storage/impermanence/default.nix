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
    fileSystems = {
      "/etc/ssh".neededForBoot = true;
      "/etc/sops".neededForBoot = true;
    };

    environment.persistence."/cache" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos-container"
      ];
    };
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/ssh"
        "/etc/nixos"
        "/etc/sops"
        "/etc/nix"
        "/etc/wireguard"
        "/var/log" # systemd journal is stored in /var/log/journal
        "/var/lib/bluetooth"
        "/var/lib/nixos" # for persisting user uids and gids
        "/var/lib/systemd"
        "/etc/NetworkManager"
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
        "zroot/${hostName}/nixos/home/michael" = sanoidDefaults;
        "zroot/${hostName}/nixos/home/shawn" = sanoidDefaults;
      };
    };
  }
