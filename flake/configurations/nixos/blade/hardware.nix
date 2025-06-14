{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
    kernelModules = ["kvm-intel"];
    kernelParams = ["nomodeset"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/70b50cf3-2428-4c1d-bd53-4207afe8e0b9";
      fsType = "ext4";
    };
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0d1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    nvidia.useNvidia = true;
  };
}
