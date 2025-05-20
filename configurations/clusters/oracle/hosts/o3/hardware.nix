{
  modulesPath,
  lib,
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
    zfs.forceImportRoot = lib.mkForce false;

    # Normal operating parameters
    tmp.cleanOnBoot = true;
    kernelModules = ["kvm-amd"];
    initrd = {
      availableKernelModules = ["virtio_pci" "virtio_blk" "xhci_pci" "ahci" "sd_mod" "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };
    zfs.extraPools = ["zroot"];
  };

  zramSwap.enable = false;
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
