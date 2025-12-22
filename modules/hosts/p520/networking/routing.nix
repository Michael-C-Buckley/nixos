{
  flake.modules.nixos.p520 = {
    services.frr.config = ''
      router ospf
       distribute-list BLOCK-DEFAULT eno1.4
       distribute-list BLOCK-DEFAULT enx2.8
       distribute-list BLOCK-DEFAULT enx3.8
      int lo
       ip ospf passive
       ip ospf area 0
      int br0
       ip ospf passive
       ip ospf area 0
      int eno1
       ip ospf cost 1000
       ip ospf area 0
      int enx2
       ip ospf cost 100
       ip ospf area 0
      int enx3
       ip ospf cost 100
       ip ospf area 0
      int eno1.3
       ip ospf cost 1010
       ip ospf area 0
      int eno1.4
       ip ospf cost 1000
       ip ospf area 0
      int enx2.7
       ip ospf cost 110
       ip ospf area 0
      int enx2.8
       ip ospf cost 100
       ip ospf area 0
      int enx3.7
       ip ospf cost 110
       ip ospf area 0
      int enx3.8
       ip ospf cost 100
       ip ospf area 0
    '';
  };
}
