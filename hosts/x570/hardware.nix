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
  ];

  environment.systemPackages = with pkgs; [
    clinfo
    wavemon
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelModules = [
      "kvm"
      "kvm-amd"
      "virtiofs"
      "9p"
      "9pnet_virtio"
      "dm-raid"
      "dm-snapshot"
    ];
    kernelParams = [
      "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
      "pcie_aspm=off"
    ];
    extraModulePackages = [ ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "uas"
        "sd_mod"
      ];
      kernelModules = [
        "dm-snapshot"
        "dm-raid"
      ];
    };
  };

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    steam-hardware.enable = true;

    intel-gpu-tools.enable = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-graphics-compiler
        intel-vaapi-driver
        intel-ocl
        ocl-icd
      ];
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  security.rtkit.enable = true; # For sound

  system.stateVersion = "26.11";

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="18:c0:4d:89:83:97", NAME="eno1"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="18:c0:4d:89:83:98", NAME="eno2"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="10:70:fd:f0:f0:3c", NAME="enx3"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="10:70:fd:f0:f0:3d", NAME="enx4"
  '';
}
