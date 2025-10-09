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
