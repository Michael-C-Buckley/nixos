# Mostly default example from Impermanence
#
# Differences in mounts:
# - Persist: persisted and ZFS snapshotted
# - Cache: persisted but no snapshots
{
  flake.modules.nixosModules.storage.impermanence = let
    commonUserCache = [
      "Downloads"
      ".cache"
      ".local"
    ];

    commonUserPersist = [
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
    ];
  in {
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
      ];

      users = {
        michael.directories = ["flakes" "nixos"] ++ commonUserCache;
        shawn.directories = commonUserCache;
      };
    };
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
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
      ];
      files = [
        "/etc/machine-id"
      ];
      users = {
        michael.directories = commonUserPersist;
        shawn.directories = commonUserPersist;
      };
    };
  };
}
