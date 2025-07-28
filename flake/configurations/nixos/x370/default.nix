_: {
  imports = [
    ./kubernetes
    ./networking
    ./hardware
  ];

  networking = {
    hostName = "x370";
  };

  virtualisation = {
    incus.enable = true;
  };

  system = {
    preset = "server";
    stateVersion = "25.11";
  };
}
