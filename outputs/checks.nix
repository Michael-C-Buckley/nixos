{inputs}: {
  x86_64-linux.pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
    src = ../.;
    hooks = {
      check-merge-conflicts.enable = true;
      deadnix.enable = true;
      detect-private-keys.enable = true;
      typos.enable = true;
      flake-checker.enable = true;
    };
  };
}
