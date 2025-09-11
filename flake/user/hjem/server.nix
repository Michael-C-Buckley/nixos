# Something in between the stripped bare default and a full graphical environment
{pkgs, ...}: let
  minGfxPkgs = import ../packageSets/minimalGraphical.nix {inherit pkgs;};
in {
  users.users.michael = {
    packages = minGfxPkgs;
  };
}
