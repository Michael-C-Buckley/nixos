{
  flake.modules.nixos.b550 = {
    services.frr.config = ''
      router ospf
       distribute-list NO-DEFAULT eno1.4
       distribute-list NO-DEFAULT eno2.6
       distribute-list NO-DEFAULT enx3.8
       distribute-list NO-DEFAULT enx4.8
      int lo
       ip ospf area 0
       ip ospf passive
      int br0
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf area 0
       ip ospf cost 1000
      int enp2
       ip ospf area 0
       ip ospf cost 400
      int enx3
       ip ospf area 0
       ip ospf cost 100
      int enx4
       ip ospf area 0
       ip ospf cost 100
      int eno1.3
       ip ospf area 0
       ip ospf cost 1000
      int eno1.4
       ip ospf area 0
       ip ospf cost 1000
      int enp2.5
       ip ospf area 0
       ip ospf cost 400
      int enp2.6
       ip ospf area 0
       ip ospf cost 400
      int enx3.7
       ip ospf area 0
       ip ospf cost 100
      int enx3.8
       ip ospf area 0
       ip ospf cost 100
      int enx4.7
       ip ospf area 0
       ip opsf cost 100
      int enx4.8
       ip ospf area 0
       ip ospf cost 100
    '';
  };
}
