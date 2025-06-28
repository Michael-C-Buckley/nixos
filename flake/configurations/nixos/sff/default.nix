# 1 has been temporarily moved to a separate location
_: {
  imports = [
    # ./kubernetes
    ./networking/routing.nix
    ./hardware.nix
  ];
  networking = {
    loopback.ipv4 = "192.168.78.140";
    hostId = "fb020cc1";
  };

  system = {
    stateVersion = "25.11";
    preset = "server";
    impermanence.enable = true;
    boot.uuid = "DF19-0E9F";
    impermanence.zrootPath = "zroot/sff1";
  };
}
