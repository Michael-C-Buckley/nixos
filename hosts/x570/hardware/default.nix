{
  config,
  lib,
  modulesPath,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.ucodenix.nixosModules.default
    ./filesystems.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernelModules = ["kvm" "kvm-amd"];
    kernelParams = ["amd_pstate=active"]; # AMD Power efficiency on Linux 6.3+
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
  };

  hardware = {
    intel-gpu-tools.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.ucodenix = {
    enable = false;
    cpuModelId = "00A20F12";
  };

  swapDevices = [];
}
