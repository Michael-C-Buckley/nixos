# Host IP definitions for hosts file generation and routing configs
# These are reused anywhere the IPs need to be referenced and serve
# as the single source of truth
{
  flake.hosts = {
    uff1.interfaces = {
      lo.ipv4 = "192.168.61.1/32";
      br1.ipv4 = "192.168.59.10/27";
      enu2.ipv4 = "192.168.60.135/28";
      br100.ipv4 = "192.168.59.39/27";
    };

    uff2.interfaces = {
      lo.ipv4 = "192.168.61.2/32";
      br1.ipv4 = "192.168.59.11/27";
      enu2.ipv4 = "192.168.60.136/28";
      br100.ipv4 = "192.168.59.40/27";
    };

    uff3.interfaces = {
      lo.ipv4 = "192.168.61.3/32";
      br1.ipv4 = "192.168.59.12/27";
      enu2.ipv4 = "192.168.60.137/28";
      br100.ipv4 = "192.168.59.41/27";
    };

    b550.interfaces = {
      lo.ipv4 = "192.168.63.6/32";
      br0.ipv4 = "192.168.56.33/27"; # TODO: realign
      br1.ipv4 = "192.168.59.9/27";
      enp2.ipv4 = "192.168.60.133/28";
      enx3.ipv4 = "192.168.60.147/28";
      enx4.ipv4 = "192.168.60.3/29";
      br100.ipv4 = "192.168.59.38/27";
    };

    p520.interfaces = {
      lo.ipv4 = "192.168.63.5/32";
      br0.ipv4 = "192.168.56.1/27"; # TODO: realign
      br1.ipv4 = "192.168.59.8/27";
      enx2.ipv4 = "192.168.60.146/28";
      enx3.ipv4 = "192.168.60.2/29";
      br100.ipv4 = "192.168.59.37/27";
    };

    x570.interfaces = {
      lo.ipv4 = "192.168.63.10/32";
      br1.ipv4 = "192.168.59.7/27";
      eno2.ipv4 = "192.168.60.132/28";
      enx3.ipv4 = "192.168.60.145/28";
      enx4.ipv4 = "192.168.60.1/29";
      br100.ipv4 = "192.168.59.36/27";
    };

    t14.interfaces = {
      lo.ipv4 = null;
    };

    o1.interfaces = {
      lo.ipv4 = null;
    };

    tempest.interfaces = {
      lo.ipv4 = null;
    };

    sff3.interfaces = {
      lo.ipv4 = null;
    };
  };
}
