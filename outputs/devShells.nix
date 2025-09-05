{pkgs}: {
  default = pkgs.mkShellNoCC {
    buildInputs = with pkgs; [
      # keep-sorted start
      (mdformat.withPlugins (
        p: with p; [mdformat-gfm mdformat-tables]
      ))
      alejandra
      biome
      deadnix
      editorconfig-checker
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
      fi
    '';
  };
}
