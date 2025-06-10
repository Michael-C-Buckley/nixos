_: {
  imports = [
    ./kubernetes
    ./networking
    ./hardware.nix
  ];

  networking = {
    hostName = "x370";
  };

  system = {
    boot.uuid = "";
    preset = "server";
    stateVersion = "25.11";
    zfs.enable = true;
    impermanence.enable = true;
  };
}
