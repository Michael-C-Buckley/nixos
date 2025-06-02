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
          # Nix
          # alejandra.enable = true;
          deadnix.enable = true;
          flake-checker.enable = true;
          statix.enable = true;
          nil.enable = true;

          # Cleanliness
          typos.enable = true;
          check-merge-conflicts.enable = true;

          # Security
          trufflehog.enable = false;
          detect-private-keys.enable = true;
        };
      };
    }
  )
