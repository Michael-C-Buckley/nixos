# Wrappers

Wrappers provide the benefit of being able to "nix"-ship a package (or derivation) with all additional components.
This is commonly going to be dependencies and configs, like Docker.
Unlike Docker, this is built with nix and has the usual nix benefits of reproducibility and deduplication, etc.

## Benefits

Packages can be `nix run` from anywhere and immediately launch fully configured.
This maximized portability and reproducibility as no components (such as dotfiles) live anywhere outside the nix-store.

This can include things like fonts, and is one of the things I do for my wrapped terminals.

## Requirements

The chief requirement is time investment and tuning.

`pkgs.symlinkJoin` is a powerful tool for wrapping packages that can additional items to the path as well as add additinoal flags to the command.

However, simple commands can have trivial builders such as `pkgs.writeShellApplication` if you just need a simple flag added.

These differ from simple shell aliases as the nix builder will include all dependences (at a minimum, a config file) and put them in the nix-store.

## Challenges

Applications that are wrapped likely have no means of alternating the configs while running.
A change will likely mean a derivation rebuild and relaunch the application.
This can be impactful if your wrapped package is your compositor (which I do, btw).

Part of that will include figuring out how to approach the wrapping to begin with.
Many CLI apps have a convenient `-c` flag for passing.

However, not all do or can be used.
Niri has one, but that will severely impact the application because suddenly `niri msg outputs` does not work.
This is because the `-c` and the config were quietly passed and now interfering.
The Niri solution to proper wrapping was to create an override for the systemd unit that `niri-session` launches, and have it include the config flag there.

Packages may also be overridden unexpectedly.
This was the case with `git` when used in conjunction with devshells.
The `mkShell` function includes `pkgs.git` in it, which will shadow a user/system path item.
This caused the wrapped config to seemingly vanish, and without dotfiles, go completely default settings.
My solution here was to surrender and link the dotfiles, despite having the wrapped git.
Sometimes the simpler and sane solution is the easier one, even if it wasn't the original goal.

You may not have additional modules to help configure the item.
Configuration will fall more along the lines of classically configuring things.
Trivial builders can help so that `pkgs.writers.writeTOML` can transfer attrsets into TOML.
This provides opportunities for using nix's core features when declaring the items.
There are frameworks to assist with this, but no large ones exist yet.
