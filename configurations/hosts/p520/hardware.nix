{
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelModules = ["kvm-intel" "virtiofs" "9p" "9pnet_virtio"];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2f81fed5-ced4-496d-a1da-1df6fd255c98";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5A10-ADAC";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/var/lib/private/ollama/models" = {
    device = "/dev/disk/by-uuid/dd30ea1b-9f02-4b97-981c-d358926fd7bc";
    fsType = "ext4";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
