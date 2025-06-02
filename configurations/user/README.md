# Michael's Home Configs

These are some home directory configurations I have. They are provided by [Home-Manager](https://github.com/nix-community/home-manager) and also by [Hjem](https://github.com/feel-co/hjem).

## Hjem

Hjem is a newer, simpler version of file linking. Useful for providing only declarative and collected dotfile management without the overhead, complexity, and potential breakage that home-manager has.

This implementation is currently primarily for my servers, where I don't have or need extensive applications and their configurations. However, I am planning on moving all my configs to this for all NixOS systems and am working toward that goal.

## Home-Manager

Home-Manager is a well-known and widely used for a variety of user-space management and configurations. Provides a lot of modules and options for declarative management.

I am currently using home-manager for declarative management on graphical, personal computers for complex application management. I will be moving to only using Home-manager on non-NixOS systems after converting everything to be Hjem compatible.

## Credits

Special thanks to those whose flakes or projects have provided inspiration and I have used configurations from:

- [Arbel's Starship toml](https://forgejo.spacetime.technology/arbel/nixos)
- [Waybar Minimal](https://github.com/ashish-kus/waybar-minimal/tree/main)

## To-Do

Just a small section of things I am working on:

- Hyprland: workspaces and binds
- Laptop dock script for hyprland
- Convert all Home-manager to Hjem (~90% completed)
- Add options to reduce total files
- Nvim (via NVF)
- Emacs (via either spacemacs or doom)
