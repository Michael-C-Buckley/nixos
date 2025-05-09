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
    #kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelPackages = (pkgs.linuxPackagesFor inputs.lava.packages.x86_64-linux.linux-lava);
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "uas" "sd_mod" "sdhci_pci"];
      kernelModules = ["dm-snapshot"];
    };
    kernelParams = [
      "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
      "microcode.amd_sha_check=off" # Linux kernel check, disable for ucodenix
    ];
    kernelModules = ["kvm" "kvm-amd" "virtiofs" "9p" "9pnet_virtio"];
    extraModulePackages = [];
  };

  # WIP: add swap
  swapDevices = [];
  networking.useDHCP = lib.mkDefault true;

  # For sound
  security.rtkit.enable = true;

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A50F00";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
