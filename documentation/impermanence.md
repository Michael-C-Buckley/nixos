# Impermanence

> [NOTICE]
> **Work in Progress**: The final schemas may change at any time.

Impermanence is a great and unique thing about NixOS. It is able to boot with just `/boot` and `/nix` mounted.
This offers a significant amount of freedom, and thus opportunity, with filesystem management.

## Resources:

[Erase Your Darlings](https://grahamc.com/blog/erase-your-darlings/): The post that started it all
[Impermanence Flake](https://github.com/nix-community/impermanence): Tools for making your system easily impermanent

## Collected Thoughts

### The benefits of Impermanence

The best topic to start off with is why, because it can be considered a risky undertaking.
Impermanence increases reproducibility and accountability, while decreasing system "drift".
NixOS itself helps considerably with this as the major components of the config are linked from the nix-store.
However, filesystems are one of the inevitably impure components of a system.

Impermanence is not quite like immutable roots that some distros feature.
It is mutable, just the state is wiped on reboot.
This prevents any unaccounted for accumulation of state that isn't explicitly tracked.

### Prerequisites

- `/` and `/nix` must be separate volumes or devices

This is the only hard and fast requirement, as `/nix` will need to be mounted early and a dependence on `/` will mean that you cannot make impermenant-by-default arrangements without formatting/re-installing.
Anyone with an already split `/nix` volume can implement impermanence at any rebuild without re-installing or wiping the drive(s).
Consequently, they could also revert from it provided the previous volumes still existed.

### Filesystem Choices

Impermanence naturally lends itself to copy-on-write filesystems, such as ZFS or Btrfs.

Non-CoW filesystems can be used, but they offer some disadvantages. You'll need to size your volumes out on creation, something that CoW does not require. LVM2 can help mitigate this, as you only have to size drives and not physically arrange them on a drive. It makes growth a lot easier, should you need to do that.

I main ZFS like it is Frank's Red Hot and I put that FS on everything. Servers, desktop, laptop, no matter what device or workload and the experience has been nothing short of amazing. Btrfs overlap is high so users could get the major benefits there too, I just went down the ZFS road. The full experience will have to be in another article.

### Finding the Natural Limits

Users should be considering their design before beginning.
Since state will need to be preserved, as it isn't guaranteed, setting some limits can be helpful.

A major decision point is whether or not to include `/home` in impermanence or fully persisted.
Impermanence on system only and not on home is largely trivial in comparison to with home.
Home persists for your various applications require a lot of time and effort to curate.

Furthermore, any other major functional component should be handled specifically.
This often means its own dataset instead of just a line item of a persistence mount.
Such items may include things like directories associated with Postgres or other extremely important items.

Likewise, finding out things to split off can be helpful.
The `/var` in FHS standards is associated with system state and can be fully persisted via a mount.
However, `/var/lib/docker` is probably not precious data that should be snapshotted and potentially replicated.
What can be done is a persistence bind for the Docker directory (or other large, easily replaceable files) to move it to another device.
One that isn't snapshotted and not taking up unneeded space.
The same can be applied to a fully persisted home and the `~/Downloads/` directory.

Additional considerations will come in from the features of your filesystem.
Compression, encryption, snapshots, etc.

## My Current Schema

As it stands, I am following *mostly* the following:

- ZFS with multiple datasets
- `/nix`: no replication
- `/persist`: replicated
- `/cache`: no replication

With the ZFS path of:

- Replicated: `zroot/${hostName}/${device}`
- Non-replicated: `zroot/local/${device}`

Hostnames are included to differentiate snapshots off the original host.
Local ones do not leave so do not matter.
`/cache` and `/nix` are local.

Output of `zls` (see my shell aliases for the full command) on my desktop at time of writing:

```
NAME                       USED  RATIO  LUSED  AVAIL
zroot                      637G  1.24x   732G  2.21T
zroot/local                594G  1.22x   669G  2.21T
zroot/local/cache         90.9G  1.37x   122G  2.21T
zroot/local/games          435G  1.14x   497G  2.21T
zroot/local/nix           27.7G  2.19x  50.5G  2.21T
zroot/local/vm            40.6G  1.00x    70K  2.21T
zroot/local/vm/cml        40.6G  1.00x    28K  2.25T
zroot/x570                42.6G  1.50x  62.6G  2.21T
zroot/x570/nixos          42.6G  1.50x  62.6G  2.21T
zroot/x570/nixos/persist  42.6G  1.50x  62.6G  2.21T
```

## Proposed Schema

I am considering migration to a different schema across my devices.

Major changes:

- Softening severity
- Device for `/var`
- Device for `/home`
- Additional datasets for directories under those

Looking likely as:

```
zroot
zroot/local
zroot/local/nix
zroot/local/cache
zroot/local/logs
zroot/$host/var
zroot/$host/home
zroot/$host/home/$user
zroot/$host/persist
```

Additional binds

`/var/cache` - cache
`/var/tmp` - cache
`/var/log` - logs
