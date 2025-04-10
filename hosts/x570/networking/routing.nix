{lib, ...}: {
  # Default Nixos will have standard priority, force to override
  # environment.etc."frr/frr.conf".source = lib.mkForce config.age.secrets.frr.path;

  environment.etc."frr/frr.conf".text = lib.mkForce ''
    ip forwarding
    ipv6 forwarding

    ip route 192.168.48.0/20 blackhole 250

    router ospf
      router-id 192.168.63.10
      default-information originate metric 550 metric-type 1

    router bgp 65100
      no bgp ebgp-requires-policy
      neighbor 192.168.240.241 remote-as 64800
      network 192.168.48.0/2

      address-family ipv4
        network 192.168.48.0/20
        neighbor 192.168.240.241 activate
      exit

    int lo
      ip ospf passive
      ip ospf area 0

    int enp8s0
      ip ospf cost 400
      ip ospf area 0
      ip ospf dead-interval 3
      ip ospf hello-interval 1

    int enp9s0
      ip ospf cost 100
      ip ospf area 0
      ip ospf dead-interval 3
      ip ospf hello-interval 1
  '';

  networking = {
    ospf.enable = true;
    bgp.enable = true;
  };

  services.frr = {
    bfdd.enable = true;
    eigrpd.enable = true;
  };
}
