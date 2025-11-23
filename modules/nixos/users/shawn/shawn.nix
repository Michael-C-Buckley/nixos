{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.shawn = {
    config,
    pkgs,
    ...
  }: let
    shell = flake.wrappers.mkFish {
      inherit pkgs;
      env = config.custom.shell.environmentVariables;
    };
  in {
    users = {
      powerUsers.members = ["shawn"];
      users.shawn = {
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = "${shell}${shell.shellPath}";
      };
    };
  };
}
