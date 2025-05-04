_: let
  lo = "192.168.78.133";
  mainIP = "192.168.65.133";
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
        addr = "192.168.254.3/29";
        mac = "f4:52:14:5e:22:20";
      };
      enmlx2 = {
        addr = "192.168.254119/29";
        mac = "f4:52:14:5e:22:21";
      };
    };
  };

  custom.routing.routerId = lo;

  networking = {
    hostId = "9db44f50";
    hostName = "ln3";
  };
}
