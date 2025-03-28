{lib, ...} : {
  # Default Nixos will have standard priority, force to override
  # environment.etc."frr/frr.conf".source = lib.mkForce config.age.secrets.frr.path;

  environment.etc."frr/frr.conf".text = lib.mkForce ''
  ip forwarding

  router ospf
    router-id 192.168.63.10
    default-information originate metric 550 metric-type 1

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

  services.frr = {
    bgpd.enable = true;
    bfdd.enable = true;
    eigrpd.enable = true;
    ospfd.enable = true;
    bgpd.options = [ "--limit-fds 2048" ];
    zebra.options = [ "--limit-fds 2048" ];
    openFilesLimit = 2048;
  };
}
