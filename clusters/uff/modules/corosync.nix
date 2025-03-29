{...}: {
  services.pacemaker.enable = true;

  services.corosync = {
    enable = true;
    clusterName = "uff";
    nodelist = [
      {
        name = "uff1";
        nodeid = 1;
        ring_addrs = [
          "192.168.254.1"
          "192.168.48.101"
        ];
      }
      {
        name = "uff2";
        nodeid = 2;
        ring_addrs = [
          "192.168.254.2"
          "192.168.48.102"
        ];
      }
      {
        name = "uff3";
        nodeid = 3;
        ring_addrs = [
          "192.168.254.3"
          "192.168.48.103"
        ];
      }
    ];
  };
}
