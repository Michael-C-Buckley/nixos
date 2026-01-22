{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
    xdg.configFile."git/config".source = flake.wrappers.mkGitConfig {inherit pkgs;};
  };
}
