# First attempt
{config, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.env = pkgs.buildEnv {
      name = "Michael's Environment";
      paths = with config.flake.packages.${system}; [
        nushell
        helix
        vscode
        zeditor
        kitty
      ];
    };
  };
}
