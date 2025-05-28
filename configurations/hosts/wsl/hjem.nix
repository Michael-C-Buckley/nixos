{
  pkgs,
  lib,
  ...
}: {
  hjem.users.michael = {
    packageList = [(lib.hiPrio pkgs.nvf)];
    programs = {
      librewolf.enable = true;
    };
  };
}
