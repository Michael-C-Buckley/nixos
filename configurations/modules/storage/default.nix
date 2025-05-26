{inputs, lib, ...}: {
  imports = [
    # ./nfs.nix
    inputs.impermanence.nixosModules.impermanence
    ./disko
    ./impermanence.nix
    ./zfs.nix
  ];

  options.system.boot.uuid = lib.mkOption {
    type = lib.types.str;
    description = "The UUID of the /boot partition.";
  };

  # Add gluster module
}
