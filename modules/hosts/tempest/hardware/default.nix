{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.tempest = {
    pkgs,
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      kernelPackages = pkgs.linuxKernel.packagesFor flake.packages.${pkgs.stdenv.hostPlatform.system}.jet2;
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
      intel-gpu-tools.enable = true;
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    nixpkgs.hostPlatform = "x86_64-linux";

    # For sound
    security.rtkit.enable = true;

    swapDevices = [];
  };
}
