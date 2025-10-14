- Setup up caching/remote building
- Nebula networking

## Restructuring

- Remove files for my user configs
- Integrate *some* Nix management of specific dots
- Git signing keys per machine
- Nixpak (browsers, vscodium, obsidian)

______________________________________________________________________

# Tasks

- Add syncoid

## Moves

Move to ZFS/storage:

```nix
let     sanoidDefaults = {
      autoprune = true;
      autosnap = true;
      hourly = 12;
      daily = 3;
      weekly = 2;
      monthly = 2;
    }; in
      services.sanoid = {
        inherit (config.system.zfs) enable;

        datasets = {
          "zroot/${hostName}/nixos/persist" = sanoidDefaults;
        };
      };
```
