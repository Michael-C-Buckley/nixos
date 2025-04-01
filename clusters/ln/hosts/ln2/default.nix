# CHANGE ALL
{...}: let
  lo = "192.168.78.132";
in {
  system.stateVersion = "24.11";

  imports = [
    ./filesystems.nix
  ];

  cluster.ln.kubernetes = {
    masterIP = "192.168.65.171";
  };

  custom = {
    networking = {
      lo.addrs = ["127.0.0.1/8" "${lo}/32"];
      eno1.addrs = ["192.168.65.171/24"];
      enmlx1 = {
        mac = "00:02:c9:39:fa:e0";
        addrs = ["192.168.254.1/29"];
      };
      enmlx2 = {
        mac = "00:02:c9:39:fa:e1";
        addrs = ["192.168.254.9/29"];
      };
    };
    routing.routerId = lo;
  };

  networking = {
    hostId = "d330b4e9";
    hostName = "ln2";
  };
}
