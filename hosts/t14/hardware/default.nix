{ config, lib, modulesPath, inputs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.ucodenix.nixosModules.default
    ./filesystems.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "uas" "sd_mod" "sdhci_pci" ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelParams = [ "amd_pstate=active" ]; # AMD Power efficiency on Linux 6.3+
    kernelModules = [ "kvm" "kvm-amd" ];
    extraModulePackages = [ ];
  };

  # WIP: add swap
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A50F00";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
