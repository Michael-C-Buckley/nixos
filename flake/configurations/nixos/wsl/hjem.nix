{
  self',
  lib,
  ...
}: {
  hjem.users.michael = {
    packageList = [(lib.hiPrio self'.packages.nvf)];
    programs = {
      custom.ns.enable = true;
      librewolf.enable = true;
    };
  };
}
