update:
    nix flake update
    npins update
    nvfetcher -c .config/nvfetcher.toml

# Do not move main nixpkgs
bump:
    nix flake update nix-darwin flake-parts hjem sops-nix
    npins update
    nvfetcher -c .config/nvfetcher.toml
