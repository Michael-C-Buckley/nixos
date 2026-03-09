{
  flake.modules.nixos.b550 = {
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
      kernelPackages = pkgs.linuxPackages_6_19;
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

    services.udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="9c:6b:00:c0:ac:92", NAME="eno1"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="c0:a1:c3:a4:13:d0", NAME="enp2"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:5f:f3:68", NAME="enx3"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:5f:f3:69", NAME="enx4"
    '';
  };
}
