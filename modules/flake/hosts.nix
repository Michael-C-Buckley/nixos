# Host IP definitions for hosts file generation and routing configs
# These are reused anywhere the IPs need to be referenced and serve
# as the single source of truth
{
  flake.hosts = {
    # UFF Cluster
    uff1 = {
      interfaces = {
        lo.ipv4 = "192.168.61.1";
        enusb1.ipv4 = "192.168.61.145";
        eno1.ipv4 = "192.168.49.31";
      };
    };

    uff2 = {
      interfaces = {
        lo.ipv4 = "192.168.61.2";
        enusb1.ipv4 = "192.168.61.146";
        eno1.ipv4 = "192.168.49.32";
      };
    };

    uff3 = {
      interfaces = {
        lo.ipv4 = "192.168.61.3";
        enusb1.ipv4 = "192.168.61.147";
        eno1.ipv4 = "192.168.49.33";
      };
    };

    p520.interfaces = {
      lo.ipv4 = "192.168.63.5";
      br0.ipv4 = "192.168.49.5";
      ens1f0.ipv4 = "192.168.61.130";
      ens1f1.ipv4 = "192.168.61.131";
    };

    x570.interfaces = {
      lo.ipv4 = "192.168.63.10";
      enp6s0.ipv4 = "192.168.49.10";
      enp7s0.ipv4 = "192.168.61.149";
      enp15s0f0.ipv4 = "192.168.61.129";
      #enp15s0f1.ipv4 = ""; # Not currently used
      wlp5s0.ipv4 = "172.16.248.10";
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
  };
}
