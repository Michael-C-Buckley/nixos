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
    environment.etc."ssh/authorized_keys.d/shawn".source = config.sops.secrets.shawn_ssh_pubkeys.path;

    users = {
      powerUsers.members = ["shawn"];
      users.shawn = {
        hashedPasswordFile = "/etc/secrets/users/shawn/hashedPassword";
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = "${shell}${shell.shellPath}";
      };
    };
  };
}
