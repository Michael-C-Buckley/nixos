# NixOS Flake

These are my main NixOS configurations for my personal systems.
I have been using NixOS for a few years now and went back and forth on growing and shrinking configs.
Currently, the configs are rather minimal and focused on what I need without anything I don't.

You may be looking for my older [NixOS flake](https://github.com/Michael-C-Buckley/nixos-legacy).
Which has a lot longer history and quite a lot going on, as mentioned coming up below.

## Major Architecture

I keep the design cordoned into major components:

- `outputs`: where the nix files containing flake output definitions are
- `modules`: houses modules by type (currently just NixOS modules)
- `packages`: definitions for packages (mainly my individual wrappers)
- `.config`: where I hide pre-commit and utility items

This keeps things relatively straight-forward.
A minimized and thoughtout structure prevents the needs for weaving together a dendritic pattern just to survive.

## Past Ventures

I've tried a lot and many things have not survived:

- Secrets
- Flake-Parts
- Dendritic
- Import-Tree (and spin-offs)
- Disko
- Nixos-anywhere
- Non-flake inputs
- Pre-commit flake
- Various Browsers
- Various Window Managers
- Split user packages in Nix Profile
- Declaring literally everything
- Split Flakes
- Non-nix Home
- Git submodules
- Custom Kernels
- ZFS

There's many reasons but they all reduce down to simplicity over complexity.
I have less NixOS devices than I used to, as many servers have gone to other platforms, for reasons.

What has survived:

- Some wrappers
- Pre-commit (not as an input)
- [NVF](https://github.com/notashelf/nvf) (in nix profile)
- Lanzaboote

When I say declaring everything, I mean it.
I had secrets, multiple browsers, heavy wrappers, even kubernetes configs.

## What is left out

This is an important section, as this rewrite as deliberately excluded features normal to many modern flakes.

The biggest departure is secrets management.

I no longer manage secrets within the flake.
Instead, I have an imperative management system I control externally.
The decision was largely driven by the complexity of secrets, coupled with the fact that my secrets don't change very often.
The removal of servers, especially kubernetes hosts, was a huge factor in the reduction of secrets.

The next mention is various "frameworks".

There's been a bunch of frameworks I've tried, each promising to make things better.
Many did - for a while.
Then the complexity either directly grew or I was tempted to keep adding onto them.

Surprising to those who know me, I've moved off of ZFS on my NixOS devices.

ZFS is still the clearly superior filesystem option, however, I just don't use the features that makes it such.
I'm not on btrfs (as a hardware config examination would show) and using just the necessary common features to get by.
Friction is radically reduced on not needing to careful interweave my ZFS and kernel versions,
since Nixpkgs rather *sucks* for maintaining a ZFS-compatible line of kernels.
Yes, I can juggle more nixpkgs pins but that is increasing complexity at a cost that wasn't helpful to me.

## What is Still Left

- Lanzaboote

I still use secureboot (mainly for work machine compatibility) and I chose Lanzaboote as the vehicle.
There is some friction, but overall it is based on and uses systemd-boot and works well.
I tried Limine, which is pretty good, but not being as "well" integrated as systemd-boot when it came to
recognizing and handling UKIs and Windows was a driving factor on going back.

- Hjem

I really thought about going framework-less and doing some systemd-tmpfiles for home files, but hjem does
lifecycle management of the links used.
That's valuable enough to keep though I may change my mind in the future.

- Flake Inputs

After going through tack, npins, nvfetcher, etc. I'm back on vanilla flake inputs.
They are getting better compared to what they were when I started and explored other options.
The inclusion of optimizations and some partially lazy trees has helped a lot.
Plus, as the community standard mechanism, everything just works with it.

Likewise, I'm not pulling appImages and wrapping them myself anymore.
The community at large supplies quite a lot of excellent work, like the Helium flake I am currently using.
