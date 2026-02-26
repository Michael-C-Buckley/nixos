# Mostly default example from Impermanence
#
# Differences in mounts:
# - Persist: persisted and ZFS snapshotted
# - Cache: persisted but no snapshots
#
# Flake Config mixes in the directories declared from Flake module options
{config, ...}: let
  inherit (config.flake) npins;
in {
  flake.modules.nixos.impermanence = {
    config,
    lib,
    ...
  }: let
    inherit (config.custom.impermanence) cache home persist var;
    inherit (lib) optionals;

    # Deprecated feature - intentionally now empty set
    #hjemUsers = builtins.attrNames config.hjem.users;
    hjemUsers = [];

    commonUser = lib.optionals home.enable [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];

    varCache = optionals var.enable [
      "/var/lib/nixos-containers"
      "/var/lib/machines"
      "/var/log"
    ];

    varPersist = optionals var.enable [
      # A generic bind for persisting
      "/var/lib/persist"

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
  in {
    imports = ["${npins.impermanence}/nixos.nix"];

    # Trigger the various logical elements that rely on this
    custom.impermanence.enable = true;

    environment.persistence."/cache" = {
      hideMounts = true;
      directories = cache.directories ++ varCache;

      inherit (cache) files;

      users = builtins.listToAttrs (map (name: {
          inherit name;
          value = {
            #inherit (config.users.users.${name}) home;
            inherit (config.custom.impermanence.cache.users.${name}) directories files;
          };
        })
        hjemUsers);
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories =
        [
          "/etc/NetworkManager"
          "/etc/wireguard"
          "/etc/secrets"
        ]
        # Filter out `/var` dirs if we are not making it impermanent
        # This prevents the needs for splitting logic in all modules
        ++ (builtins.filter (x: !(lib.hasPrefix "/var") x) persist.directories) ++ varPersist;

      files =
        [
          "/etc/machine-id"
        ]
        ++ persist.files;

      users = builtins.listToAttrs (map (name: {
          inherit name;
          value = {
            directories = persist.users.${name}.directories ++ persist.allUsers.directories ++ commonUser;
            files = persist.users.${name}.files ++ persist.allUsers.files;
          };
        })
        hjemUsers);
    };
  };
}
