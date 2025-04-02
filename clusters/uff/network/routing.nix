{config, ...}: {
  networking.ospf.enable = true;

  services.frr = {
    bfdd.enable = true;
    bgpd.enable = true;
    ospf6d.enable = true;
    vrrpd.enable = true;

    config = ''
      ip forwarding
      ipv6 forwarding
      router ospf
       router-id ${config.custom.uff.loopbackIPv4}
       default-information originate metric 600 metric-type 1
      int lo
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf area 0
       ip ospf cost 400
       uo
      int enusb1
       ip ospf area 0
       ip ospf cost 100
    '';
  };
}
