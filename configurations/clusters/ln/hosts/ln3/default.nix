{config, ...}: let
  inherit (config.networking) loopback;
  mainIP = "192.168.65.133";

in {
  system.boot.uuid = "B34E-A49B";

  # Entire thing due for a refactor
  cluster.ln = {
    kubernetes.masterIP = mainIP;
    networking = {
      lo.addr = "${loopback.ipv4}/32"; 
      eno1.addr = "${mainIP}/24";
      enmlx1 = {
        addr = "192.168.254.3/29";
        mac = "f4:52:14:5e:22:20";
      };
      enmlx2 = {
        addr = "192.168.254.119/29";
        mac = "f4:52:14:5e:22:21";
      };
    };
  };

  custom.routing.routerId = loopback.ipv4;

  networking = {
    hostId = "9db44f50";
    hostName = "ln3";
    loopback.ipv4 = "192.168.78.133";
  };
}
