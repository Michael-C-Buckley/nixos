{config, ...}: let
  inherit (config.networking) loopback;
  mainIP = "192.168.65.131";
in {
  imports = [./filesystems.nix];

  # WIP: legacy options not long for this world
  cluster.ln.kubernetes.masterIP = mainIP;
  custom.routing.routerId = loopback.ipv4;

  networking = {
    hostId = "d330b4e9";
    loopback.ipv4 = "192.168.78.131";
  };

  networkd = {
    enmlx1 = {
      mac = "00:02:c9:39:fa:e0";
      addresses.ipv4 = ["192.168.254.1/29"];
    };
    enmlx2 = {
      mac = "00:02:c9:39:fa:e1";
      addresses.ipv4 = ["192.168.254.17/29"];
    };
  };

  system = {
    boot.uuid = "406D-8DEA";
  };
}
