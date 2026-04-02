{
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
      kernelPackages = pkgs.linuxPackages_zen;
      kernelModules = ["kvm" "kvm-amd" "virtiofs" "9p" "9pnet_virtio" "mt7921e"];
      kernelParams = [
        "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
        "pcie_aspm=off"
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
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="18:c0:4d:89:83:97", NAME="eno1"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="18:c0:4d:89:83:98", NAME="eno2"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="10:70:fd:f0:f0:3c", NAME="enx3"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="10:70:fd:f0:f0:3d", NAME="enx4"
    '';
  };
}
