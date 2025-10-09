{
  flake.modules.nixosModules.users = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption;
    inherit (types) listOf str;
    power = config.users.powerUsers;
  in {
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
        groups.hydra = {};
        powerUsers.groups = ["networkmanager" "wheel" "video" "update"];
        users = {
          michael = {
            isNormalUser = true;
            extraGroups = power.groups;
          };
          shawn = {
            isNormalUser = true;
            extraGroups = power.groups;
          };
          # Used for remote builds
          builder = {
            isNormalUser = true;
            packages = with pkgs; [git curl];
            openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOjEc/vHaQ6Dj5aey5L5tSzEvp0tOTkdnRRG9z0uWCc"];
          };
        };
      };
    };
  };
}
