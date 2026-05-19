{inputs}: systems: basePath: let
  nvfetcher = ../../_sources/generated.nix;
  npins = import ../../npins;
  inherit (inputs.nixpkgs.lib) foldl' recursiveUpdate;
in
  # Map over the imported files
  foldl' recursiveUpdate {} (
    map (
      file:
        builtins.listToAttrs (
          # Next, map over the systems to be applied
          map (
            system: {
              name = system;
              value = import file {
                inherit inputs system npins nvfetcher;
                pkgs = import inputs.nixpkgs {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
            }
          )
          systems
        )
    )
    basePath
  )
