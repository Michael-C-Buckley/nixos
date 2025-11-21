# Wrapped starship with custom config bundled
{
  perSystem = {pkgs, ...}: let
    starshipConfig = import ./_config.nix {inherit pkgs;};
  in {
    packages.starship = pkgs.symlinkJoin {
      name = "starship";
      paths = [pkgs.starship];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/starship \
          --set STARSHIP_CONFIG ${starshipConfig}
      '';
    };
  };
}
