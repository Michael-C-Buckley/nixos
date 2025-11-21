{
  flake.modules.nixos.shawn = {config, ...}: let
    inherit (config.hjem.users) michael;
  in {
    hjem.users.shawn = {
      rum.programs = {
        inherit (michael.rum.programs) fish starship;
      };
    };
    users = {
      powerUsers.members = ["shawn"];
      users.shawn = {
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
      };
    };
  };
}
