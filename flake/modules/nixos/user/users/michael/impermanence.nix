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
  inherit (lib) mkIf;
  inherit (config.system) impermanence;
  privateDir = directory: {
    inherit directory;
    mode = "0700";
  };
in
  mkIf impermanence.enable {
    environment.persistence = {
      "/cache".users.michael = {
        directories = [
          "Downloads"
          "nixos" # My system flake is in ~/
          ".cache/yarn"
          ".cache/pip"
          ".cache/thumbnails"
          ".cache/cosmic"
          ".cache/nix"
          ".cache/nix-index"
          ".cache/nix-search-tv"
          ".local/share/.cargo"
          ".local/share/.rustup"
          ".local/share/fish"
          ".local/share/flatpak/"
        ];
      };
      "/persist".users.michael = {
        directories = [
          "projects"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          ".config/cosmic"
          ".config/Bitwarden"
          ".config/fish"
          ".config/sops"
          ".config/telegram"
          ".config/dconf"
          ".pki"
          ".local/state/wireplumber"
          (privateDir ".gnupg")
          (privateDir ".ssh")
          (privateDir ".local/share/keyrings")
        ];
        files = [
          ".screenrc"
        ];
      };
    };
  }
