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
      ssh-to-age
      ssh-to-pgp
      statix
      taplo
      tig
      treefmt
      trufflehog
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
