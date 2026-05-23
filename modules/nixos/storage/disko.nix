# Provides the modules and defaults I use
{
  inputs,
  flake,
  ...
}: {
  imports = [
    inputs.disko-zfs.nixosModules.default
    "${flake.npins.disko}/module.nix"
  ];
}
