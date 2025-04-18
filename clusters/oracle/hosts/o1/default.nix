{...}: {
  imports = [
    ./hardware.nix
    ./networking
  ];

  system = {
    stateVersion = "24.11";
    zfs.enable = true;
  };

  services = {
    nix-serve.enable = true;
    # This service is causing 25.05 to fail because it can't find group 30000 for whatever reason
    logrotate.enable = false;
  };
}
