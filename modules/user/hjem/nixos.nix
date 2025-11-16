{
  config,
  inputs,
  ...
}: {
  flake.hjemConfig.nixos = {
    imports = [
      inputs.hjem.nixosModules.default
      config.flake.hjemConfig.default
    ];
  };
}
