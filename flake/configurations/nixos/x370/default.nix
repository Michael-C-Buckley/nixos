_: {
  imports = [
    ./kubernetes
    ./networking
    ./hardware.nix
  ];

  networking = {
    hostName = "x370";
  };

  virtualisation = {
    incus.enable = true;
  };

  system = {
    boot.uuid = "B187-B440";
    preset = "server";
    stateVersion = "25.11";
    zfs.enable = true;
    impermanence.enable = true;
  };
}
