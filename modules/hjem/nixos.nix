{
  config,
  inputs,
  ...
}: {
  flake.hjemConfigs.nixos.imports = [
    inputs.hjem.nixosModules.default
    config.flake.hjemConfigs.default
  ];
}
