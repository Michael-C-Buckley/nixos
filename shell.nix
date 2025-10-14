# This is a simple set of tools that doesn't require pinning, just get them from the host
{pkgs ? import <nixpkgs> {}}:
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
    ++ [
      # Tool to find best GPG signing key as part of my shell
      (pkgs.callPackage ./packages/gpg-find-key.nix {})
    ];

  shellHook = ''
    lefthook install
    git fetch
    git status --short --branch
    #git submodule foreach --quiet 'git fetch >/dev/null 2>&1 && echo "$name: $(git rev-list --count HEAD..origin/$(git rev-parse --abbrev-ref HEAD)) commits behind"'
  '';
}
