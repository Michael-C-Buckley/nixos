{
  flake.modules.nixos.p520 = {
    services.frr = {
      bfdd.enable = true;

      config = ''
        ip forwarding

        int lo
          ip ospf passive
          ip ospf area 0

        int br0
          ip ospf passive
          ip ospf area 0

        int eno1
          ip ospf area 0
          ip ospf cost 1000

        int ens1f0
          ip ospf area 0
          ip ospf cost 100

        int ens1f1
          ip ospf area 0
          ip ospf cost 100
      '';
    };
  };
}
