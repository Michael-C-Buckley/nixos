{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      name = "default";
      buildInputs = with pkgs; [
        # keep-sorted start
        (mdformat.withPlugins (
          p: with p; [mdformat-gfm mdformat-tables]
        ))
        alejandra
        biome
        deadnix
        git
        keep-sorted
        lefthook
        nil
        rage
        shellcheck
        shfmt
        sops
        statix
        taplo
        treefmt
        typos
        # keep-sorted end
      ];

      shellHook = ''
        lefthook install

        if [ -d .git ]; then
          git fetch
          git status --short --branch
          git submodule foreach --quiet 'git fetch >/dev/null 2>&1 && echo "$name: $(git rev-list --count HEAD..origin/$(git rev-parse --abbrev-ref HEAD)) commits behind"'
        fi
      '';
    };
  };
}
