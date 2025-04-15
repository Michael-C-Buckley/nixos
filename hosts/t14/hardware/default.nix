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
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "uas" "sd_mod" "sdhci_pci"];
      kernelModules = ["dm-snapshot"];
    };
    kernelParams = ["amd_pstate=active" "microcode.amd_sha_check=off"]; # AMD Power efficiency on Linux 6.3+
    kernelModules = ["kvm" "kvm-amd"];
    extraModulePackages = [];
  };

  # WIP: add swap
  swapDevices = [];
  networking.useDHCP = lib.mkDefault true;

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A50F00";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
