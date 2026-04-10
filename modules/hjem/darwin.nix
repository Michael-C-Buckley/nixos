{
  config,
  inputs,
  ...
}: {
  flake.custom.hjemConfigs.darwin = {
    imports = builtins.attrValues {
      inherit (config.flake.custom.hjemConfigs) default kitty ghostty zed;
      hjem-darwin = inputs.hjem.darwinModules.default;
    };

    hjem.users.michael = {
      directory = "/Users/michael";
    };
  };
}
