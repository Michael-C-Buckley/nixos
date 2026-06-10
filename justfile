update:
    tack update
    nvfetcher -c .config/nvfetcher.toml

# Do not move main nixpkgs
bump:
    tack update dotfiles hjem flake-parts rootbeer disko disko-zfs jail nixos-core tack sops-nix binhost noctalia
    nvfetcher -c .config/nvfetcher.toml
