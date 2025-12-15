# First attempt at home-manager in quite a while
# This probably will not get much use and you probably should not
# copy it, I suggest looking elsewhere for home-manager inspiration
# as I will be attempting crazy madness and doing things which probably
# will break, and break a lot
{
  flake.modules.homeManager.default = {pkgs, ...}: {
    home = {
      username = "michael";
      homeDirectory = "/home/michael";

      packages = with pkgs; [
        nh # limited on non-NixOS systems but still useful
      ];
    };

    programs.home-manager.enable = true;
  };
}
