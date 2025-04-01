_: let
  lo = "192.168.78.133";
in {
  system.stateVersion = "24.05";

  imports = [
    ./filesystems.nix
  ];

  # CONVERT
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

  networking = {
    hostId = "9db44f50";
    hostName = "ln3";
  };
}
