{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.x570 = {
    config,
    lib,
    modulesPath,
    pkgs,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      kernelPackages = pkgs.linuxKernel.packagesFor flake.packages.${pkgs.stdenv.hostPlatform.system}.jet3;
      kernelModules = ["kvm" "kvm-amd" "virtiofs" "9p" "9pnet_virtio"];
      kernelParams = [
        "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
        "zfs.zfs_arc_max=17179869184" # 16GB max
        "zfs.zfs_arc_min=4294967296" # 4GB min
      ];
      extraModulePackages = [];
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
        kernelModules = ["dm-snapshot"];
      };
    };

    hardware = {
      enableAllFirmware = true;
      enableAllHardware = true;
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    security = {
      rtkit.enable = true;
      tpm2.enable = true;
    };
  };
}
