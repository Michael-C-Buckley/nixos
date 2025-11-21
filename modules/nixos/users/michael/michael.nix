{
  flake.modules.nixos.michael = {config, ...}: {
    users = {
      powerUsers.members = ["michael"];
      users.michael = {
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
      };
    };
  };
}
