# A basic Root user configuration that pulls in select aspects of my configs
# *This does depend on importing my hjem configs
{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.root = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.users.users) michael shawn;
    shell = flake.wrappers.mkFish {
      inherit pkgs;
      env = config.custom.shell.environmentVariables;
    };
  in {
    users.users.root = {
      hashedPasswordFile = "/etc/secrets/users/root/hashedPassword";
      shell = "${shell}${shell.shellPath}";
      openssh.authorizedKeys.keys = michael.openssh.authorizedKeys.keys ++ shawn.openssh.authorizedKeys.keys;
    };

    hjem.users.root = {
      enable = true;
      user = "root";
      directory = "/root";
    };
  };
}
