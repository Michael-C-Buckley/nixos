_: {
  networking = {
    ospf.enable = true;
    bgp.enable = true;
    eigrp.enable = true;
  };

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
}
