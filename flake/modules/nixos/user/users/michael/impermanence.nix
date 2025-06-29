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
in
  mkIf impermanence.enable {
    environment.persistence = {
      "/cache".users.michael = {
        directories = [
          "Downloads"
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
        ];
      };
      "/persist".users.michael = {
        directories = [
          "projects"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "nixos" # My system flake is in ~/
          ".config/cosmic"
          ".config/Bitwarden"
          ".config/fish"
          ".config/sops"
          ".config/telegram"
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
