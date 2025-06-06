_: {
  services.frr = {
    bgpd.enable = true;
    bfdd.enable = true;
    bgpd.options = ["--limit-fds 2048"];
    zebra.options = ["--limit-fds 2048"];
    openFilesLimit = 2048;

    config = ''
      int lo
        ip ospf passive
        ip ospf area 0

      int enp5s0
        ip ospf area 0
        ip ospf cost 100
    '';
  };
}
