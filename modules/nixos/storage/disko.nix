# Provides the modules and defaults I use
{inputs, ...}: {
  imports = [
    inputs.disko-zfs.nixosModules.default
    "${inputs.disko}/module.nix"
  ];
}
