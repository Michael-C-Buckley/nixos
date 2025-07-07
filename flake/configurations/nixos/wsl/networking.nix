_: {
  networking = {
    ospf.enable = true;
    eigrp.enable = true;
  };

  services.frr = {
    config = ''
      ip forwarding
      ipv6 forwarding

      router eigrp 1
        network 192.168.50.32/27
    '';
  };
}
