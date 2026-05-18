{
  flake.modules.nixos.uff = {
    services.frr.config = ''
      int lo
       ip ospf area 0
       ip ospf passive
      int br1
       ip ospf area 0
       ip ospf cost 1000
      int enu2
       ip ospf area 0
       ip ospf cost 400
      !
    '';
  };
}
