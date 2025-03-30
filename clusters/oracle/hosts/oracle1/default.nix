{...}: {
  imports = [
    ./hardware.nix
    ./networking
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      netbootxyz.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "24.11";

  # This service is causing 25.05 to fail because it can't find group 30000 for whatever reason
  services.logrotate.enable = false;
}
