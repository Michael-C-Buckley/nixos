# Mostly default example from Impermanence
#
# Differences in mounts:
# - Persist: persisted and ZFS snapshotted
# - Cache: persisted but no snapshots
#
# Flake Config mixes in the directories declared from Flake module options
{
  inputs,
  config,
  ...
}: let
  inherit (config.host.impermanence) cache persist;
in {
  flake.nixosModules.impermanence = {config, ...}: let
    commonUserCache =
      [
        "Downloads"
        ".cache"
        ".local"
        "flakes"
        "nixos"
      ]
      ++ cache.user.directories;

    commonUserPersist =
      [
        "Documents"
        "Pictures"
        "projects"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
      ]
      ++ persist.user.directories;
    /*
    sanoidDefaults = {
      autoprune = true;
      autosnap = true;
      hourly = 12;
      daily = 3;
      weekly = 2;
      monthly = 2;
    };
    */

    mkUserSet = {
      directories,
      files,
    }:
      builtins.listToAttrs (map (name: {
          inherit name;
          value = {inherit directories files;};
        })
        config.users.powerUsers.members);
  in {
    imports = [inputs.impermanence.nixosModules.impermanence];
    # To make sure keys are available for sops decryption
    fileSystems."/etc/ssh".neededForBoot = true;

    environment.persistence."/cache" = {
      hideMounts = true;
      directories =
        [
          # A generic bind for caching
          "/var/lib/cache"
          "/var/lib/nixos-containers"
          "/var/lib/machines"
        ]
        ++ cache.directories;

      inherit (cache) files;

      users = mkUserSet {
        directories = commonUserCache;
        inherit (cache.user) files;
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories =
        [
          "/etc/ssh"
          "/etc/nixos"
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
        ]
        ++ persist.directories;

      files =
        [
          "/etc/machine-id"
        ]
        ++ persist.files;

      users = mkUserSet {
        directories = commonUserPersist;
        inherit (persist.user) files;
      };
    };
  };
}
