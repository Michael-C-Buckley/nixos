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
    kernelPackages = pkgs.linuxPackages_7_2;
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

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="9c:6b:00:c0:ac:92", NAME="eno1"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="c0:a1:c3:a4:13:d0", NAME="enp2"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:5f:f3:68", NAME="enx3"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:5f:f3:69", NAME="enx4"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="28:16:ad:4b:1a:31", NAME="wlo1"
  '';
}
