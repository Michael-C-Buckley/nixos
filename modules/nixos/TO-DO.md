# Tasks

- Impermance linking upper and lower layers
- Bluetooth

## Moves

Move to networking:

```nix
boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
};
```

Move to security:

```nix
boot.initrd.systemd.emergencyAccess = config.users.users.root.hashedPassword;
```

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
