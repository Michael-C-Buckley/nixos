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

    b550.interfaces = {
      lo.ipv4 = "192.168.63.6";
      br0.ipv4 = "192.168.56.33";
      eno1.ipv4 = "192.168.49.6";
      enp2.ipv4 = "192.168.61.150";
      enx3.ipv4 = "192.168.61.132";
      enx4.ipv4 = "192.168.61.133";
    };

    p520.interfaces = {
      lo.ipv4 = "192.168.63.5";
      br0.ipv4 = "192.168.56.1";
      eno1.ipv4 = "192.168.49.5";
      enx2.ipv4 = "192.168.61.130";
      enx3.ipv4 = "192.168.61.131";
    };

    x570.interfaces = {
      lo.ipv4 = "192.168.63.10";
      eno1.ipv4 = "192.168.49.10";
      eno2.ipv4 = "192.168.61.149";
      enx3.ipv4 = "192.168.61.129";
      #enx4.ipv4 = "";
      wlan1.ipv4 = "172.16.248.10";
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
