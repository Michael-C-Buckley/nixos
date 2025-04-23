{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    tmp.cleanOnBoot = true;
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };
    zfs.extraPools = ["zroot"];
  };

  fileSystems = {
    "/nix" = {
      device = "zroot/root/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "zroot/root/home";
      fsType = "zfs";
    };
    "/" = {
      device = "zroot/root/nixos";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/585A-8DF4";
      fsType = "vfat";
    };
  };

  zramSwap.enable = true;
}
