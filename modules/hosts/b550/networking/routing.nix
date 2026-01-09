{
  flake.modules.nixos.b550 = {
    services.frr.config = ''
      int lo
       ip ospf area 0
       ip ospf passive
      int br0
       ip ospf area 0
       ip ospf passive
      int br1
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
    '';
  };
}
