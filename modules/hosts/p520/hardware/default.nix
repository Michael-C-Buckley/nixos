{inputs, ...}: {
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
      kernelPackages = pkgs.linuxKernel.packagesFor inputs.nix-kernels.packages.${pkgs.stdenv.hostPlatform.system}.jet1;
      binfmt.emulatedSystems = ["aarch64-linux"];
      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
        kernelModules = ["dm-snapshot"];
      };
      kernelParams = [
        "zfs.zfs_arc_max=34359738368" # 32GB max
        "zfs.zfs_arc_min=8589934592" # 8GB min
      ];
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
