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
      shell = "${shell}${shell.shellPath}";
      initialHashedPassword = "$6$oIx8hLUFc.Adg5yl$1/tSkuisZT1NDgAueIkbJ7Qb91Ed7i9Ge1EbKfzCGr7WuZZAHY/4fjLgRwi2B3Ofar4X99hqeXhB2aVbbcgra0";
      openssh.authorizedKeys.keys = michael.openssh.authorizedKeys.keys ++ shawn.openssh.authorizedKeys.keys;
    };

    hjem.users.root = {
      enable = true;
      user = "root";
      directory = "/root";
    };
  };
}
