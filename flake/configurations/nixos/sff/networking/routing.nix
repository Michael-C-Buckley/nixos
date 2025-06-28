{config, ...}: let
  lo = config.networking.loopback.ipv4;
in {
  networking = {
    ospf.enable = true;
  };

  services.frr = {
    bfdd.enable = true;

    config = ''
      ip forwarding
      ipv6 forwarding
      router ospf
       router-id ${lo}
      int lo
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf area 0
    '';
  };
}
