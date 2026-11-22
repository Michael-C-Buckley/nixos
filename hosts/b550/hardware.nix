{
  config,
  pkgs,
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
    kernelPackages = lib.mkDefault pkgs.linuxPackages_7_2;
    kernelModules = [
      "kvm"
      "kvm-amd"
      "virtiofs"
      "9p"
      "9pnet_virtio"
    ];
    kernelParams = [
      "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
    ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "uas"
        "sd_mod"
      ];
      kernelModules = [ "dm-snapshot" ];
    };
  };

  hardware = {
    enableAllFirmware = true;
    enableAllHardware = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.11";

  security = {
    rtkit.enable = true;
    tpm2.enable = true;
  };
}
