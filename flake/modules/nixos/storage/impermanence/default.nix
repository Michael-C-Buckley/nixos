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
        "/var/lib/libvirt"
        "/var/lib/docker"
        "/var/lib/incus"
        "/var/lib/gns3"
        "/var/lib/nixos-container"
      ];
    };
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/ssh"
        "/etc/nixos"
        "/etc/sops"
        "/etc/nix/secrets"
        "/etc/wireguard"
        "/var/log" # systemd journal is stored in /var/log/journal
        "/var/lib/bluetooth"
        "/var/lib/nixos" # for persisting user uids and gids
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
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
        "zroot/${hostName}/persist" = {
          hourly = 50;
          daily = 15;
          weekly = 3;
          monthly = 1;
        };
      };
    };
  }
