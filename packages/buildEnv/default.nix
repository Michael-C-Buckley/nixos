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
      # Intended for lightweight hosts that I want something on
      slimEnv = pkgs.buildEnv {
        name = "Michael's slim env";
        paths = with local; [
          nushell
        ];
      };
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
        paths = with local;
          [
            nushell
            helix
            vscode
            zeditor
            kitty
            helium
          ]
          ++ (with pkgs; [
            # Communication
            legcord
            signal-desktop
            materialgram

            # Productivity
            novelwriter
          ]);
      };
    };
  };
}
