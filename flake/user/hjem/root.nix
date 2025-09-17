# A basic Root user configuration that pulls in select aspects of my configs
{
  self,
  config,
  pkgs,
  system,
  ...
}: let
  inherit (config.hjem.users) michael;
  michaelFish = michael.rum.programs.fish;
in {
  users.users.root.shell = pkgs.fish;

  hjem.users.root = {
    enable = true;
    user = "root";
    directory = "/root";

    # Gets at least NVF minimal
    packages = [
      self.packages.${system}."nvf-minimal"
    ];

    rum = {
      programs.fish = {
        enable = true;
        config = ''
          set -U fish_greeting
          fish_config prompt choose arrow
        '';
        # Mirror the functionality I give to my user
        inherit (michaelFish) aliases functions plugins;
      };
    };
  };
}
