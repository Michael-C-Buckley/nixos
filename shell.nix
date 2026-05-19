# This is a simple set of tools that doesn't require pinning, just get them from the host
{
  pkgs ? import <nixpkgs> {},
  extraPkgs ? [],
  ...
}:
pkgs.mkShellNoCC {
  name = "default";
  buildInputs = with pkgs;
    [
      # Lua
      stylua
      selene

      # Nix
      alejandra
      deadnix
      statix
      nil

      # Yaml
      yamlfmt
      yamllint

      # Formatting
      mdformat
      biome
      shfmt
      taplo
      treefmt

      # Hooks
      lefthook
      shellcheck
      typos
    ]
    ++ extraPkgs;

  # Note to myself for pushing config
  # git config url."git@github.com:".pushInsteadOf "https://github.com/"
  shellHook = ''
    export PATH="$PATH:/usr/local/bin"
    if [ -z "''${CI:-}" ]; then
      lefthook install
      git fetch
      git status --short --branch
    fi
  '';
}
