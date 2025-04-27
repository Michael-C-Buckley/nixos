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
    zfs.forceImportRoot = true; # Workaround until Disko ZFS multihost is fixed
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod"];
      kernelModules = [];
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
