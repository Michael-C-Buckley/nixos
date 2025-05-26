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
       router-id ${config.custom.sff.loopbackIPv4}
      int lo
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf area 0
       ip ospf cost 400
       uo
      int enx520p1
       ip ospf area 0
       ip ospf cost 40
      int enx520p2
       ip ospf area 0
       ip ospf cost 40
    '';
  };
}
