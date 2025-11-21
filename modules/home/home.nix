# First attempt at home-manager in quite a while
# This probably will not get much use and you probably should not
# copy it, I suggest looking elsewhere for home-manager inspiration
# as I will be attempting crazy madness and doing things which probably
# will break, and break a lot
{config, ...}: {
  flake.modules.homeManager.default = {
    pkgs,
    lib,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.flake.packages.${system}) fish starship;
  in {
    programs.home-manager.enable = true;

    home = {
      username = "michael";
      homeDirectory = "/home/michael";

      stateVersion = lib.mkDefault "25.11";

      packages = [
        fish
        starship
      ];
    };
  };
}
