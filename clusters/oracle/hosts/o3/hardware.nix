{modulesPath, lib, ...}: {
  imports = [
    ../../modules/disko.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  features.boot = "grub";

  boot = {
    tmp.cleanOnBoot = true;
    kernelModules = ["kvm-amd"];
    initrd = {
      availableKernelModules = [ "virtio_pci" "virtio_blk" "xhci_pci" "ahci" "sd_mod" "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };
    zfs.extraPools = ["zroot"];
    zfs.forceImportRoot = lib.mkForce true;
  };

  zramSwap.enable = true;
}
