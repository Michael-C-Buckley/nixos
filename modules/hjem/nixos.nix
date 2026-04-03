{
  config,
  inputs,
  ...
}: {
  flake.custom.hjemConfigs.nixos.imports = [
    inputs.hjem.nixosModules.default
    config.flake.custom.hjemConfigs.default
  ];
}
