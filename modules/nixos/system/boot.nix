{lib, ...}: {
  boot.loader = {
    systemd-boot = {
      enable = lib.mkDefault true;
      configurationLimit = 20;
      netbootxyz.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}
