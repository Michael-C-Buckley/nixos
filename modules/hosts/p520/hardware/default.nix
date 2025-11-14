{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.p520 = {
    config,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      kernelPackages = pkgs.linuxKernel.packagesFor flake.packages.${pkgs.stdenv.hostPlatform.system}.jet1-kernel_6_16;
      binfmt.emulatedSystems = ["aarch64-linux"];
      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
        kernelModules = ["dm-snapshot"];
      };
      extraModprobeConfig = "options kvm_intel nested=1";
      kernelModules = ["kvm-intel" "virtiofs" "9p" "9pnet_virtio"];
      extraModulePackages = [];
      zfs.extraPools = ["zhdd"];
    };

    swapDevices = [];

    security.tpm2.enable = true;

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware = {
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
      ksm.enable = true;
    };
  };
}
