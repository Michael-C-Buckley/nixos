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
          ip ospf area 0
          ip ospf cost 100
      '';
    };
  };
}
