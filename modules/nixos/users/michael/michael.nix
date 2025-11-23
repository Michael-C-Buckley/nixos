{config, ...}: let
  inherit (config) flake;

  envars = {
    NH_FLAKE = "/home/michael/nixos";
  };
in {
  flake.modules.nixos.michael = {
    config,
    pkgs,
    ...
  }: {
    users = {
      powerUsers.members = ["michael"];
      users.michael = {
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = flake.wrappers.mkFish {
          inherit pkgs;
          env =
            config.custom.shell.environmentVariables
            // config.hjem.users.michael.environment.sessionVariables
            // envars;
        };
      };
    };
  };
}
