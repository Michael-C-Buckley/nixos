# This is a simple set of tools that doesn't require pinning, just get them from the host
{
  pkgs ? import <nixpkgs> {},
  extraPkgs ? [],
}:
pkgs.mkShellNoCC {
  name = "default";
  buildInputs = with pkgs;
    [
      # Formatting
      mdformat
      alejandra
      biome
      shfmt
      taplo
      treefmt

      # Hooks
      lefthook
      shellcheck
      deadnix
      statix
      typos
    ]
    ++ extraPkgs;

  shellHook = ''
    lefthook install
    git fetch
    git status --short --branch
    export PATH="$PATH:/usr/local/bin"
  '';
}
