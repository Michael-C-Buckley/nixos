# This is a simple set of tools that doesn't require pinning, just get them from the host
{
  pkgs ? import <nixpkgs> {},
  extraPkgs ? [],
}:
pkgs.mkShellNoCC {
  name = "default";
  buildInputs = with pkgs;
    [
      just

      # Formatting
      mdformat
      alejandra
      biome
      shfmt
      taplo
      treefmt
      yamlfmt
      yamllint

      # Hooks
      lefthook
      shellcheck
      deadnix
      statix
      typos
      nil
    ]
    ++ extraPkgs;

  # Note to myself for pushing config
  # git config url."git@github.com:".pushInsteadOf "https://github.com/"
  shellHook = ''
    lefthook install
    git fetch
    git status --short --branch
    export PATH="$PATH:/usr/local/bin"
  '';
}
