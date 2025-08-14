{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./filesystems.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernelModules = ["kvm" "kvm-amd" "virtiofs" "9p" "9pnet_virtio"];
    kernelParams = [
      "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
    ];
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
  };

  hardware = {
    enableAllFirmware = true;
    enableAllHardware = true;
    intel-gpu-tools.enable = true;
    graphics.useIntel = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  security = {
    rtkit.enable = true;
    tpm2.enable = true;
  };

  swapDevices = [];
}
