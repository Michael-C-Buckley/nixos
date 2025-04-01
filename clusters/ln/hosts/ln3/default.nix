# LN3 Configuration File
{...}: let
  # Match IP to the networking interface
  kubeMasterIP = "192.168.65.13";
  kubeMasterHostname = "ln3";
  kubeMasterApiServerPort = 6443;
  kubeRoles = ["node"];

  lo = "192.168.78.133";
in {
  system.stateVersion = "24.05";

  imports = [
    ./filesystems.nix
  ];

  custom = {
    networking = {
      lo.addrs = ["127.0.0.1/8" "${lo}/32"];
      eno1.addrs = ["192.168.65.133/24"];
      enmlx1 = {
        mac = "f4:52:14:5e:22:20";
        addrs = ["192.168.254.3/29"];
      };
      enmlx2 = {
        mac = "f4:52:14:5e:22:21";
        addrs = ["192.168.254.11/29"];
      };
    };
    routing.routerId = lo;
  };

  services.ceph.global.fsid = "f1e87dff-46b4-4334-8f0c-fd8705a5e2e5";

  networking = {
    hostId = "9db44f50";
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
