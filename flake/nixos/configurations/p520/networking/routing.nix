{config, ...}: let
  inherit (config.networking) loopback;
in {
  networking = {
    ospf.enable = true;
    bgp.enable = true;
    eigrp.enable = true;
  };

  services.frr = {
    bfdd.enable = true;

    config = ''
      ip forwarding

      router eigrp 1
        network 192.168.50.32/27
        network ${loopback.ipv4}
        variance 1

      int lo
        ip ospf passive
        ip ospf area 0

      int br0
        ip ospf area 0
        ip ospf cost 100

      int br200
        ip ospf area 0
        ip ospf passive
    '';
  };
}
