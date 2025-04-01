_: let
  lo = "192.168.78.131";
  mainIP = "192.168.65.171";
in {
  system.stateVersion = "24.05";

  imports = [
    ./filesystems.nix
  ];

  cluster.ln = {
    kubernetes.masterIP = mainIP;
    networking = {
      lo.addr = "${lo}/32";
      eno1.addr = "${mainIP}/24";
      enmlx1 = {
        addr = "192.168.254.1/29";
        mac = "00:02:c9:39:fa:e0";
      };
      enmlx2 = {
        addr = "192.168.254.9/29";
        mac = "00:02:c9:39:fa:e1";
      };
    };
  };

  custom.routing.routerId = lo;

  networking = {
    hostId = "d330b4e9";
    hostName = "ln1";
  };
}
