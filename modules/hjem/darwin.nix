{
  config,
  inputs,
  ...
}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.darwin = {config, ...}: let
    inherit (config.custom.hjem) username;
  in {
    imports = builtins.attrValues {
      inherit (flake.custom.hjemConfigs) default kitty ghostty zed;
      hjem-darwin = inputs.hjem.darwinModules.default;
    };

    hjem.users.${username} = {
      directory = "/Users/${username}";
    };
  };
}
