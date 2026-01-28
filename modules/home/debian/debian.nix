{config, ...}: let
  inherit (config.flake.modules) homeManager;
in {
  flake.modules.homeManager.debian = {
    imports = with homeManager; [
      bash
      default
      wsl
    ];
    home.stateVersion = "25.11";
    home.sessionVariables = {
      COLORTERM = "truecolor";
    };
  };
}
