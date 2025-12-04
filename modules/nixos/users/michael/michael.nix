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
  }: let
    shell = flake.wrappers.mkFish {
      inherit pkgs;
      env =
        config.custom.shell.environmentVariables
        // config.hjem.users.michael.environment.sessionVariables
        // envars;
    };
  in {
    environment.etc."ssh/authorized_keys.d/michael".source = config.sops.secrets.michael_ssh_pubkeys.path;

    users = {
      powerUsers.members = ["michael"];
      users.michael = {
        hashedPasswordFile = "/etc/secrets/users/michael/hashedPassword";
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = "${shell}${shell.shellPath}";
      };
    };
  };
}
