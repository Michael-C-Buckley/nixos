{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (types) listOf str;
in {
  options.users.powerUsers = {
    members = mkOption {
      type = listOf str;
      default = [];
      description = "List of users you want to add to almost all groups";
    };
    groups = mkOption {
      type = listOf str;
      default = ["wheel"];
      description = "List of groups to add to power users";
    };
  };

  config = {
    users = {
      powerUsers = {
        members = ["michael"];
        groups = ["networkmanager" "wheel" "video" "plugdev" "wireshark"];
      };
      users = {
        michael.extraGroups = config.users.powerUsers.groups;
      };
    };
  };
}
