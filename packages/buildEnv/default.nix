# First attempt
{config, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    local = config.flake.packages.${system};
  in {
    packages = {
      termEnv = pkgs.buildEnv {
        # Extra packages for CLI hosts like development servers
        name = "Michael's terminal env";
        paths = with local; [
          nushell
          helix
        ];
      };
      fullEnv = pkgs.buildEnv {
        # Fully loaded graphical environments
        name = "Michael's full env";
        paths = builtins.attrValues {
          inherit
            (local)
            nushell
            helix
            vscode
            zeditor
            ghostty
            kitty
            helium
            ;
          inherit
            (pkgs)
            # Communication
            legcord
            signal-desktop
            materialgram
            # Productivity
            novelwriter
            ;
        };
      };
    };
  };
}
