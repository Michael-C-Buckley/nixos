{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (types) listOf str;
  power = config.users.powerUsers;
in {
  imports = [
    inputs.nix-secrets.nixosModules.users
  ];

  options.users.powerUsers = {
    members = mkOption {
      type = listOf str;
      default = ["michael" "shawn"];
      description = "List of users you want to add to almost all groups";
    };
    groups = mkOption {
      type = listOf str;
      default = ["networkmanager" "wheel" "video"];
      description = "List of groups to add to power users";
    };
  };

  config = {
    users = {
      powerUsers.groups = ["networkmanager" "wheel" "video" "update"];
      groups.update = {};
      users = {
        michael = {
          isNormalUser = true;
          extraGroups = power.groups;
        };
        shawn = {
          isNormalUser = true;
          extraGroups = power.groups;
        };
      };
    };
  };
}
