# My Nix & NixOS Flake

> [!NOTE]
> This project is still being written and not yet achieved parity with my other iterations.
> Progress is ongoing and this notice will disappear when I get it "current" with my closed flake.

This is the 7th generation of rewrite on my flake since I've come to nixos.

Significant amounts of things have changed over time.
I've changed onto and off-of of some patterns, designs, and techniques that have led
to various places and taught me so much.
Invariably, I'll continue that trend as each iteration lets me experiments.

## What's New This Time Around

### No More Dendritic

I've moved away from dendritic patterns.
They have substantially helped with large flakes,
though having tighter designs makes the need redundant.

### Finix

I read the documentation for finit and finix, and was impressed.
There will be configs that come up and grow as I spend time working on them.
I am not protesting NixOS or systemd.
This is purely an experiment, and I will be multi-booting nixos and other things
which include other distros and even occasionally windows.

## Major Frameworks

### Native Wrappers

I do use `pkgs.symlinkJoin` on occasion for wrapping my own packages.
It is mainly for ergonomics and not some desire to purge things from my
systems, like home files.

### Finix

A NixOS spin that replaced PID 1 from systemd to finit.
Suitable for daily driving by power users of both linux and nix.
Not necessarily recommended for someone who isn't strongly confident in both.

### Hjem

Hjem is still the user home tool I'll be using.
Simple, clean, elegeant.
Now with more both `nix-darwin` and standalone.

### Portability

This is an implicit one, though I want my computing experience to be durable as I progress.
That was the appeal to come to NixOS in the first place.
However, nix and nixos are not prisons for my systems and configurations.
As such, certain aspects will have more "raw" implementations.

These include:

- Providing my own modules and solutions
- Keeping dotfiles in pure text format with minimal interpolation

I'm buffered against upstream changes for important things, as well as the ability
to take these dots and use them anywhere.
