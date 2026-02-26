# First attempt
{config, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.fullEnv = pkgs.buildEnv {
      name = "Michael's Environment";
      paths = with config.flake.packages.${system};
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
}
