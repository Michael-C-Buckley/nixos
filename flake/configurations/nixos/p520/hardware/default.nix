{
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./filesystems.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelModules = ["kvm-intel" "virtiofs" "9p" "9pnet_virtio"];
    extraModulePackages = [];
    zfs.extraPools = ["zhdd"];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    nvidia.useNvidia = false; # Currently using AMD now
    ksm.enable = true;
  };

  fileSystems = {
    "/data" = {
      device = "zhdd/data";
      fsType = "zfs";
    };
  };
}
