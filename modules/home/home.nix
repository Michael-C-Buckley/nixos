# First attempt at home-manager in quite a while
# This probably will not get much use and you probably should not
# copy it, I suggest looking elsewhere for home-manager inspiration
# as I will be attempting crazy madness and doing things which probably
# will break, and break a lot
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.default = {
    pkgs,
    lib,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;

    # My shell
    shell = flake.wrappers.mkFish {
      inherit pkgs;
      env = {NH_FLAKE = "/home/michael/nixos";};
    };
  in {
    programs = {
      # Generates completions but also uses my wrapped one, best of both worlds
      fish = {
        enable = true;
        package = shell;
      };
      home-manager.enable = true;
    };

    home = {
      username = "michael";
      homeDirectory = "/home/michael";

      stateVersion = lib.mkDefault "25.11";

      packages = with pkgs; [
        nh # limited on non-NixOS systems but still useful
      ];
    };
  };
}
