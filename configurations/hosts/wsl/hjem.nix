{
  pkgs,
  lib,
  ...
}: {
  hjem.users.michael = {
    packageList = [(lib.hiPrio pkgs.nvf)];
    apps = {
      browsers.librewolf.enable = true;
    };
  };
}
