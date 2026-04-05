# This is a simple set of tools that doesn't require pinning, just get them from the host
{
  pkgs ? import <nixpkgs> {},
  extraPkgs ? [],
}: let
  # Wrap the pre-commit to not interfere with anyone's PATH for tools they use
  runtimeEnv = pkgs.buildEnv {
    name = "lefthook-runtime-env";
    pathsToLink = ["/bin"];
    paths = with pkgs; [
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
      shellcheck
      typos
    ];
  };

  lefthook = pkgs.symlinkJoin {
    name = "lefthook";
    paths = [pkgs.lefthook];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/lefthook \
        --prefix PATH : ${runtimeEnv}/bin
    '';
  };
in
  pkgs.mkShellNoCC {
    name = "default";
    buildInputs =
      [
        pkgs.just
        lefthook
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
