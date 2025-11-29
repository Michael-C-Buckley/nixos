# A basic Root user configuration that pulls in select aspects of my configs
# *This does depend on importing my hjem configs
{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfig.root = {
    config,
    pkgs,
    ...
  }: let
    shell = flake.wrappers.mkFish {
      inherit pkgs;
      env = config.custom.shell.environmentVariables;
    };
  in {
    users.users.root = {
      hashedPasswordFile = "/etc/secrets/root/hashedPassword";
      shell = "${shell}${shell.shellPath}";
    };

    hjem.users.root = {
      enable = true;
      user = "root";
      directory = "/root";
    };
  };
}
