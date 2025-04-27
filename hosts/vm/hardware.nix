{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    # Force Import seems to be required for the firstr boot of the device
    # when created using Disko per this repo's settings.
    # It can be remove afterward.
    zfs.forceImportRoot = lib.mkForce true;

    # Normal operational settings which do not require tampering
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod"];
      kernelModules = [];
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "25.05";
}
