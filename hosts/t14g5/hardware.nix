{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./filesystems.nix
  ];

  boot = {
    initrd = {
      includeDefaultModules = false;
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
        # The following are to ensure that keyboards work for unlock of luks
        "i8042"
        "atkbd"
        "usbhid"
        "hid_generic"
      ];
    };
    kernelParams = [
      "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
    ];
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
    extraModulePackages = [ ];
  };

  networking.useDHCP = lib.mkDefault true;

  security.rtkit.enable = true; # For sound

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "26.11";
}
