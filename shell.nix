# This is a simple set of tools that doesn't require pinning, just get them from the host
{
  pkgs ? import <nixpkgs> { },
  extraPkgs ? [ ],
  ...
}:
let
  shellEnv = pkgs.buildEnv {
    name = "nixos-shell-env";
    paths =
      with pkgs;
      [
        # Nix
        nixfmt
        deadnix
        statix
        nil

        # Formatting
        mdformat
        shfmt
        taplo
        treefmt

        # Hooks
        lefthook
        shellcheck
        typos
      ]
      ++ extraPkgs;

  };
in
pkgs.mkShellNoCC {
  name = "default";
  buildInputs = [ shellEnv ];
  # Note to myself for pushing config
  # git config url."git@github.com:".pushInsteadOf "https://github.com/"
  shellHook = ''
    if ! lefthook check-install >/dev/null 2>&1; then
      lefthook install
    fi
    git fetch
    git status --short --branch
  '';
}
