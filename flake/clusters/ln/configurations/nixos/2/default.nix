{config, ...}: let
  inherit (config.networking) loopback;
  mainIP = "192.168.65.132";
in {
  # WIP: legacy options not long for this world
  cluster.ln.kubernetes.masterIP = mainIP;
  custom.routing.routerId = loopback.ipv4;

  networking = {
    hostId = "d33ab4df";
    loopback.ipv4 = "192.168.78.132";
  };

  networkd = {
    enmlx1 = {
      mac = "";
      addresses.ipv4 = ["192.168.254.2/29"];
    };
    enmlx2 = {
      mac = "";
      addresses.ipv4 = ["192.168.254.18/29"];
    };
  };

  system = {
    boot.uuid = "AAAA-AAAA";
    impermanence.zrootPath = "zroot/ln2";
  };
}
