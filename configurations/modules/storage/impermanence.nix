# Mostly default example from Impermanence
#
# Differences in mounts:
# - Persist: persisted and ZFS snapshotted
# - Cache: persisted but no snapshots
{config, ...}: {
  # To make sure keys are available for sops decryption
  fileSystems."/etc/ssh".neededForBoot = true;

  environment.persistence."/cache" = {
    hideMounts = true;
    users.michael.directories = [
      "Downloads"
      ".cache/yarn"
      ".local/share/.cargo"
      ".local/share/.rustup"
      ".local/share/fish"
      ".cache/pip"
      ".cache/thumbnails"
    ];
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
      "/etc/nix/secrets"
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
    users.michael = {
      directories = [
        "projects"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "nixos" # My system flake is in ~/
        ".config/zen"
        ".cache/zen"
        ".config/vivaldi"
        ".config/Bitwarden"
        ".config/fish"
        ".config/sops"
        ".config/Signal"
        ".config/telegram"
        ".config/BraveSoftware"
        ".config/dconf"
        ".config/legcord"
        ".cache/nix-index"
        ".cache/nix-search-tv"
        ".pki"
        ".local/state/wireplumber"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/direnv"
      ];
      files = [
        ".screenrc"
      ];
    };
  };

  services.sanoid = {
    enable = config.system.zfs.enable;

    datasets = {
      "zroot/persist" = {
        hourly = 50;
        daily = 15;
        weekly = 3;
        monthly = 1;
      };
    };
  };
}
