_: {
  networking = {
    ospf.enable = true;
    bgp.enable = true;
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
        ip ospf dead-interval 3
        ip ospf hello-interval 1

      router ospf
        router-id 192.168.48.5
    '';
  };
}
