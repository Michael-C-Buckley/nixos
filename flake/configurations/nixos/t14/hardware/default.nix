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
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "uas" "sd_mod" "sdhci_pci"];
      kernelModules = ["dm-snapshot"];
    };
    kernelParams = [
      "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
    ];
    kernelModules = ["kvm" "kvm-amd" "virtiofs" "9p" "9pnet_virtio"];
    extraModulePackages = [];
  };

  networking.useDHCP = lib.mkDefault true;

  # For sound
  security.rtkit.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
