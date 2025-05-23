{
  self,
  system,
  lib,
  ...
}: {
  hjem.users.michael = {
    packageList = [(lib.hiPrio self.packages.${system}.nvf-default)];
    apps = {
      browsers.librewolf.enable = true;
    };
  };
}
