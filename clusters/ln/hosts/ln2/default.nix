# CHANGE ALL
{...}: let
  lo = "192.168.78.132";
  mainIP = "192.168.65.12";
in {
  system.stateVersion = "24.11";

  imports = [
    ./filesystems.nix
  ];

  # POPULATE WHEN BUILT
  cluster.ln = {
    kubernetes.masterIP = mainIP;
    networking = {
      lo.addr = "${lo}/32";
      eno1.addr = "${mainIP}/24";
      enmlx1 = {
        addr = "192.168.254.2/29";
        mac = "";
      };
      enmlx2 = {
        addr = "192.168.254.10/29";
        mac = "";
      };
    };
  };

  custom.routing.routerId = lo;

  networking = {
    hostId = "";
    hostName = "ln2";
  };
}
