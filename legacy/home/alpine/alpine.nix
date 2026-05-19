{config, ...}: let
  inherit (config.flake.modules) homeManager;
in {
  flake.modules.homeManager.alpine = {
    imports = with homeManager; [
      default
      wsl
    ];
    custom.systemd.use = false;
    home.stateVersion = "25.11";
    home.sessionVariables = {
      COLORTERM = "truecolor";
    };
  };
}
