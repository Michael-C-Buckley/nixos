{inputs}: let
  inherit (inputs) nixpkgs pre-commit-hooks;
  systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
  forAllSystems = nixpkgs.lib.genAttrs systems;
in
  forAllSystems (
    system: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
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
  )