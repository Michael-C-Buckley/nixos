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
    kernelModules = ["kvm" "kvm-amd" "virtiofs" "9p" "9pnet_virtio"];
    kernelParams = [
      "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
      "microcode.amd_sha_check=off" # Linux kernel check, disable for ucodenix
    ];     extraModulePackages = [];
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

  # For sound
  security.rtkit.enable = true;

  services.ucodenix = {
    enable = false; # Desktop is suffering CPU crashes, dump the extra microcode
    cpuModelId = "00A20F12";
  };

  swapDevices = [];
}
