{
  modules,
  ...
}:
{
  imports = [
    ../../modules/finix/presets/base.nix
    ../../modules/finix/system/limine.nix
    modules.dhcpcd
  ];

  # Initial x86_64 UEFI/libvirt layout; match these labels to the guest disk.
  boot = {
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
      "sd_mod"
      "sr_mod"
    ];
    kernelParams = [
      "console=tty0"
      "console=ttyS0,115200n8"
    ];
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/finix";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=1777" ];
    };
  };

  programs = {
    limine.maxGenerations = 5;
    resolvconf.enable = true;
  };

  services = {
    udev.enable = true;
    dhcpcd.enable = true;
    getty.ttys = [
      "tty1"
      "ttyS0"
    ];
  };

  finit.ttys.ttyS0.baud = 115200;
}
