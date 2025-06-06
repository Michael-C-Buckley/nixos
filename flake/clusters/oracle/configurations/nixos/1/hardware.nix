{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "virtio_scsi"];
      kernelModules = [];
    };
    kernelModules = ["nls_cp437" "nls_iso8859-1"];
    extraModulePackages = [];
  };

  # WIP: Convert to Impermanence
  fileSystems = lib.mkForce {
    "/boot" = lib.mkForce {
      device = "/dev/disk/by-uuid/82F3-455E";
      fsType = " vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/nix" = {
      device = "rpool/root/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/root/home";
      fsType = "zfs";
    };
    "/" = lib.mkForce {
      device = "rpool/root/nixos";
      fsType = "zfs";
    };
  };

  swapDevices = [];
  networking.useDHCP = true;
  nixpkgs.hostPlatform = "aarch64-linux";
}
