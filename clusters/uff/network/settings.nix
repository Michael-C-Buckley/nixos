_: {
  networking = {
    networkmanager.enable = true;
    hosts = {
      # /etc/hosts
      # UFF cluster anycast & loopbacks
      "192.168.61.0" = ["uffCluster"];
      "192.168.61.1" = ["uff1"];
      "192.168.61.2" = ["uff2"];
      "192.168.61.3" = ["uff3"];
    };
    useDHCP = false;
    nameservers = [
      # WIP: setup my own DNS
      "1.1.1.1"
    ];
  };
}
