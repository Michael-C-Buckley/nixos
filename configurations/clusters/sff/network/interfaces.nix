{...}: let
  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  networking = {
    interfaces = {
      # WIP: Transitioning from bridge back to base interfaces, options not yet changed
      eno1.useDHCP = false;

      # L3 reachable loopback for anycast
      lo.ipv4.addresses = [
        (addr "192.168.61.4" 32)
      ];
    };
  };
}
