# A basic Root user configuration that pulls in select aspects of my configs
# *This does depend on importing my hjem configs
{config, ...}: let
  inherit (config.flake) packages;
in {
  flake.modules.nixos.hjem-root = {
    config,
    pkgs,
    ...
  }: {
    users.users.root.shell = pkgs.fish;

    hjem.users.root = {
      enable = true;
      user = "root";
      directory = "/root";

      # Gets at least NVF minimal
      packages = [packages.${pkgs.system}.nvf-minimal];

      rum.programs = {
        fish = {
          enable = true;
          config = ''
            set -U fish_greeting
            fish_config prompt choose arrow
          '';
          # Mirror the functionality I give to my user
          inherit (config.hjem.users.michael.rum.programs.fish) aliases functions plugins;
        };
        # Copy my starship exactly for now
        inherit (config.hjem.users.michael.rum.programs) starship;
      };
    };
  };
}
