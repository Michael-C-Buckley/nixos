{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./filesystems.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "virtio_scsi"];
      kernelModules = [];
    };
    kernelModules = ["nls_cp437" "nls_iso8859-1"];
    extraModulePackages = [];
  };

  swapDevices = [];

  networking.useDHCP = true;
  nixpkgs.hostPlatform = "aarch64-linux";
}
