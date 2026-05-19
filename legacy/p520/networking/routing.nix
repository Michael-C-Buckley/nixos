{
  flake.modules.nixos.p520 = {
    services.frr.config = ''
      int lo
       ip ospf passive
       ip ospf area 0
      int br0
       ip ospf passive
       ip ospf area 0
      int br1
       ip ospf cost 1000
       ip ospf area 0
      int enx2
       ip ospf cost 100
       ip ospf area 0
      int enx3
       ip ospf cost 100
       ip ospf area 0
    '';
  };
}
