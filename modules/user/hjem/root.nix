# A basic Root user configuration that pulls in select aspects of my configs
# *This does depend on importing my hjem configs
{
  flake.hjemConfig.root = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config.hjem.users.michael.rum) programs;
  in {
    users.users.root.shell = pkgs.fish;

    hjem.users.root = {
      enable = true;
      user = "root";
      directory = "/root";

      rum.programs = {
        fish = {
          enable = true;
          config = ''
            set -U fish_greeting
            fish_config prompt choose arrow
          '';
          # Mirror the functionality I give to my user
          inherit (programs.fish) aliases functions plugins;
        };
        # Copy my starship exactly for now
        starship = lib.recursiveUpdate programs.starship {
          settings.character = {
            success_symbol = "[▼](bold red)";
            error_symbol = "[▽](bold red)";
          };
        };
      };
    };
  };
}
