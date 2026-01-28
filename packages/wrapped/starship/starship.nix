{config, ...}: let
  inherit (config.flake.wrappers) mkStarshipConfig mkStarship;
in {
  perSystem = {pkgs, ...}: {
    packages.starship = mkStarship {inherit pkgs;};
  };

  flake.wrappers = {
    mkStarshipConfig = {
      pkgs,
      extraConfig ? {},
    }:
      import ./_config.nix {inherit pkgs extraConfig;};

    mkStarship = {
      pkgs,
      extraConfig ? {},
      buildInputs ? [],
    }:
      pkgs.symlinkJoin {
        name = "starship";
        paths = [pkgs.starship];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/starship \
            --set STARSHIP_CONFIG ${mkStarshipConfig {inherit pkgs extraConfig;}}
        '';
      };
  };
}
