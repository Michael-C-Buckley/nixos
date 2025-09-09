_: {
  imports = [
    ./hardware
    ./networking
  ];

  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  # For remote building
  #  It's a 4 vCPU server, don't overload it
  nix.settings = {
    cores = 2;
    max-jobs = 2;
  };

  system = {
    boot.uuid = "12CE-A600";
    stateVersion = "25.11";
    preset = "cloud";
    zfs.enable = true;
    impermanence.enable = true;
  };
}
