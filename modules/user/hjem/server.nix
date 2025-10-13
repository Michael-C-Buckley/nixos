# Something in between the stripped bare default and a full graphical environment
{pkgs, ...}: {
  hjem.users.michael = {
    packages = import ../packageSets/minimalGraphical.nix {inherit pkgs;};
  };
}
