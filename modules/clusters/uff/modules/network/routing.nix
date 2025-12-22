{
  flake.modules.nixos.uff = {
    services.frr.config = ''
      router ospf
       distribute-list BLOCK-DEFAULT eno1.4
       distribute-list BLOCK-DEFAULT eno2.6
      int lo
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf area 0
       ip ospf cost 1000
      int enu2
       ip ospf area 0
       ip ospf cost 400
      int eno1.3
       ip ospf area 0
       ip ospf cost 1000
      int eno1.4
       ip ospf area 0
       ip ospf cost 1000
      int enu2.5
       ip ospf area 0
       ip ospf cost 400
      int enu2.6
       ip ospf area 0
       ip ospf cost 400
      !
    '';
  };
}
