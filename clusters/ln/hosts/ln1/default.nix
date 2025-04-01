# LN1 Configuration File
{...}: let
  # Match IP to the networking interface
  kubeMasterIP = "192.168.65.171";
  kubeMasterHostname = "ln1";
  kubeMasterApiServerPort = 6443;
  kubeRoles = ["master" "node"];

  lo = "192.168.78.131";
in {
  system.stateVersion = "24.05";

  imports = [
    ./filesystems.nix
  ];

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

  services.ceph.global.fsid = "f3fe85df-db19-4c93-b51c-9f3f9f41ca07";

  networking = {
    hostId = "d330b4e9";
    hostName = kubeMasterHostname;
    extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
  };

  services.kubernetes = {
    roles = kubeRoles;
    masterAddress = kubeMasterIP;
    apiserverAddress = "https://${kubeMasterIP}:${toString kubeMasterApiServerPort}";
    apiserver = {
      allowPrivileged = true;
      securePort = kubeMasterApiServerPort;
      advertiseAddress = kubeMasterIP;
    };
  };
}
