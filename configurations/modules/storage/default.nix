{inputs, ...}: {
  imports = [
    # ./nfs.nix
    inputs.impermanence.nixosModules.impermanence
    ./disko
    ./impermanence.nix
    ./zfs.nix
  ];

  # Add gluster module
}
