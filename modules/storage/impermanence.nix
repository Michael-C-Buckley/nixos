# Mostly default example from Impermanence
#
# Differences in mounts:
# - Persist: persisted and ZFS snapshotted
# - Cache: persisted but no snapshots
{
  environment.persistence."/cache" = {
    hideMounts = true;
    users.michael.directories = [
      "Downloads"
      ".cache/yarn"
      ".local/share/.cargo"
      ".local/share/.rustup"
      ".cache/nix-index"
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
        ".config/Bitwarden"
        ".config/fish"
        ".config/sops"
        ".config/vivaldi"
        ".config/signal"
        ".config/telegram"
        ".config/discord"
        ".config/BraveSoftware"
        ".config/dconf"
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
}
