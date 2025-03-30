{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    tmp.cleanOnBoot = true;
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8def4bfb-8542-4652-857a-b413ee53b4c8";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/1835-FDD0";
      fsType = "vfat";
    };
  };

  zramSwap.enable = true;
}
