# My starship is a custom fusion of some rather basic and popular other
# prompts with inspiration from: Robby Russell, Pure, Astronaut
#
# It has also been heavily chopped down where every bit of random info
# is not included because it is useless.  Just the good and relevant
# things have kept.
{config, ...}: let
  inherit (config.flake.wrappers) mkStarshipConfig mkStarship;
in {
  perSystem = {pkgs, ...}: {
    packages.starship = mkStarship {inherit pkgs;};
  };

  flake.wrappers = {
    # Expose just the config if I ever wanted it
    mkStarshipConfig = {
      pkgs,
      extraConfig ? {},
      useCharacter ? false,
    }:
      import ./_config.nix {inherit pkgs extraConfig useCharacter;};

    mkStarship = {
      pkgs,
      extraConfig ? {},
      useCharacter ? false,
    }: let
      cfg = mkStarshipConfig {inherit pkgs extraConfig useCharacter;};

      printCfg = config.flake.functions.printConfig {
        inherit cfg pkgs;
        name = "starship-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "starship";
        paths = [pkgs.starship];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/starship \
            --set STARSHIP_CONFIG ${cfg}
        '';
      };
  };
}
