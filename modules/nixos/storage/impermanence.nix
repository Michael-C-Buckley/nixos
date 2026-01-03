# Mostly default example from Impermanence
#
# Differences in mounts:
# - Persist: persisted and ZFS snapshotted
# - Cache: persisted but no snapshots
#
# Flake Config mixes in the directories declared from Flake module options
{inputs, ...}: {
  flake.modules.nixos.impermanence = {
    config,
    lib,
    ...
  }: let
    inherit (config.custom.impermanence) cache home persist var;

    hjemUsers = builtins.attrNames config.hjem.users;

    commonUser = lib.optionals home.enable [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];

    varCache = lib.optionals var.enable [
      # A generic bind for caching
      "/var/lib/cache"
      "/var/lib/nixos-containers"
      "/var/lib/machines"
      "/var/log"
    ];

    varPersist = lib.optionals var.enable [
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
    imports = [inputs.impermanence.nixosModules.impermanence];

    # Trigger the various logical elements that rely on this
    custom.impermanence.enable = true;

    # To make sure secrets are available for sops decryption
    # SSH keys are not included because I seal them systemd-creds and persist elsewhere
    # If you use agenix/sops-nix then you will need to make sure keys are available early during boot
    fileSystems = {
      # Secrets are impurely kept out of the repo and managed externally
      "/etc/secrets".neededForBoot = true;
    };

    environment.persistence."/cache" = {
      hideMounts = true;
      directories = cache.directories ++ varCache;

      inherit (cache) files;

      users = builtins.listToAttrs (map (name: {
          inherit name;
          value = {
            #inherit (config.users.users.${name}) home;
            home =
              if name == "root"
              then "/root"
              else "/home/${name}";
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
        ++ persist.directories ++ varPersist;

      files = ["/etc/machine-id"] ++ persist.files;

      users = builtins.listToAttrs (map (name: {
          inherit name;
          value = {
            home =
              if name == "root"
              then "/root"
              else "/home/${name}";
            directories = persist.users.${name}.directories ++ persist.allUsers.directories ++ commonUser;
            files = persist.users.${name}.files ++ persist.allUsers.files;
          };
        })
        hjemUsers);
    };
  };
}
