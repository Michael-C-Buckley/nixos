{lib, ...} : {
  # Default Nixos will have standard priority, force to override
#   environment.etc."frr/frr.conf".source = lib.mkForce config.age.secrets.frr.path;

  environment.etc."frr/frr.conf".text = lib.mkForce ''
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

  services.frr = {
    bgpd.enable = true;
    bfdd.enable = true;
    ospfd.enable = true;
    bgpd.options = [ "--limit-fds 2048" ];
    zebra.options = [ "--limit-fds 2048" ];
    openFilesLimit = 2048;
  };
}
