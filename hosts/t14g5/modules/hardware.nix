{ pkgs, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "uas"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [
        "dm-snapshot"
        "dm_crypt"
        "dm_mod"
        "btrfs"
        # Keep the built-in and USB keyboards available for LUKS unlock.
        "i8042"
        "atkbd"
        "usbhid"
        "hid_generic"
      ];
    };
    kernelPackages = pkgs.linuxPackages_xanmod_stable;
    kernelParams = [ "amd_pstate=active" ];
    kernelModules = [
      "kvm"
      "kvm-amd"
      "virtiofs"
      "9p"
      "9pnet_virtio"
      "dm-snapshot"
      "dm_crypt"
      "dm_mod"
      "btrfs"
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;
}
