# The common hardware of the cluster
{
  flake.modules.nixos.uff-shared = {
    config,
    pkgs,
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
      kernelPackages = pkgs.linuxKernel.packages.linux_6_16;
      kernelModules = ["kvm-intel" "virtiofs" "9p" "9pnet_virtio"];
      extraModulePackages = [];
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    # WIP: Move to nodes
    system.stateVersion = "25.11";
  };
}
