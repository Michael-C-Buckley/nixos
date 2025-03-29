{config, ...}: {
  services.frr = {
    bgpd.enable = true;
    ospfd.enable = true;

    config = ''
      ip forwarding
      ipv6 forwarding
      router ospf
       router-id ${config.custom.uff.loopbackIPv4}
       default-information originate metric 600 metric-type 1
      int lo
       ip ospf area 0
       ip ospf passive
      int br0
       ip ospf area 0
       ip ospf hello-interval 1
       ip ospf dead-interval 3
       ip ospf cost 400
       uo
      int enusb1
       ip ospf area 0
       ip ospf hello-interval 1
       ip ospf dead-interval 3
       ip ospf cost 100
    '';
  };
}
