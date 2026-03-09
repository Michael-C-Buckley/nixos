{
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
      kernelPackages = pkgs.linuxPackages_6_19;
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

    services.udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="f4:93:9f:ef:97:c5", NAME="eno1"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:44:86:68", NAME="enx2"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:44:86:69", NAME="enx3"
    '';
  };
}
