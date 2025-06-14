_: {
  imports = [
    ./kubernetes
    ./networking
    ./hardware.nix
    ./fans.nix
  ];

  networking = {
    hostName = "blade";
  };

  virtualisation = {
    incus.enable = false;
  };

  system = {
    boot.uuid = "153A-8BC0";
    preset = "server";
    stateVersion = "24.11";
    zfs.enable = false;
    impermanence.enable = false;
  };
}
