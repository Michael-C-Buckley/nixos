{modulesPath, ...}: {
  imports = [
    ../../modules/disko.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    tmp.cleanOnBoot = true;
    kernelModules = ["kvm-amd"];
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };
    zfs.extraPools = ["zroot"];
  };

  zramSwap.enable = true;
}
