{lib, ...}: {
  system = {
    zfs.enable = true;
    impermanence.enable = lib.mkDefault true;
  };

  swapDevices = [];
}
