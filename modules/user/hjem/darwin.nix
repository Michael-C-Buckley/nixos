{
  config,
  inputs,
  ...
}: {
  flake.hjemConfig.darwin = {
    imports = [
      inputs.hjem.darwinModules.default
      config.flake.hjemConfig.default
    ];

    hjem.users.michael = {
      directory = "/Users/michael";
    };
  };
}
