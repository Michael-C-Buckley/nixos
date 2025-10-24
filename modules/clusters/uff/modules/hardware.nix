# The common hardware of the cluster
{
  flake.modules.uff.shared = {
    config,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod"];
        kernelModules = ["dm-snapshot"];
      };
      kernelModules = ["kvm-intel" "virtiofs" "9p" "9pnet_virtio"];
      extraModulePackages = [];
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };
}
