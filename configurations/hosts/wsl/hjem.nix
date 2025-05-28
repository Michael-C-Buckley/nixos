{
  pkgs,
  lib,
  ...
}: {
  hjem.users.michael = {
    packageList = [(lib.hiPrio pkgs.nvf)];
    programs = {
      custom.ns.enable = true;
      librewolf.enable = true;
    };
  };
}
