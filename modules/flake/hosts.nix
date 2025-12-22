# Host IP definitions for hosts file generation and routing configs
# These are reused anywhere the IPs need to be referenced and serve
# as the single source of truth
{
  flake.hosts = {
    uff1.interfaces = {
      lo.ipv4 = "192.168.61.1";
      eno1.ipv4 = "192.168.49.31";
      enu2.ipv4 = "192.168.61.145";
      eno1-3.ipv4 = "192.168.59.10";
      eno1-4.ipv4 = "192.168.59.42";
      enu2-5.ipv4 = "192.168.59.74";
      enu2-6.ipv4 = "192.168.59.106";
    };

    uff2.interfaces = {
      lo.ipv4 = "192.168.61.2";
      enu2.ipv4 = "192.168.61.146";
      eno1.ipv4 = "192.168.49.32";
      eno1-3.ipv4 = "192.168.59.11";
      eno1-4.ipv4 = "192.168.59.43";
      enu2-5.ipv4 = "192.168.59.75";
      enu2-6.ipv4 = "192.168.59.107";
    };

    uff3.interfaces = {
      lo.ipv4 = "192.168.61.3";
      enu2.ipv4 = "192.168.61.147";
      eno1.ipv4 = "192.168.49.33";
      eno1-3.ipv4 = "192.168.59.12";
      eno1-4.ipv4 = "192.168.59.44";
      enu2-5.ipv4 = "192.168.59.76";
      enu2-6.ipv4 = "192.168.59.108";
    };

    b550.interfaces = {
      lo.ipv4 = "192.168.63.6";
      br0.ipv4 = "192.168.56.33";
      eno1.ipv4 = "192.168.49.6";
      enp2.ipv4 = "192.168.61.150";
      enx3.ipv4 = "192.168.61.133";
      enx4.ipv4 = "192.168.61.134";
      eno1-3.ipv4 = "192.168.59.9";
      eno1-4.ipv4 = "192.168.59.41";
      enp2-5.ipv4 = "192.168.59.73";
      enp2-6.ipv4 = "192.168.59.105";
      enx3-7.ipv4 = "192.168.59.137";
      enx3-8.ipv4 = "192.168.59.169";
      enx4-7.ipv4 = "192.168.59.143";
      enx4-8.ipv4 = "192.168.59.175";
    };

    p520.interfaces = {
      lo.ipv4 = "192.168.63.5";
      br0.ipv4 = "192.168.56.1";
      eno1.ipv4 = "192.168.49.5";
      enx2.ipv4 = "192.168.61.131";
      enx3.ipv4 = "192.168.61.132";
      eno1-3.ipv4 = "192.168.59.8";
      eno1-4.ipv4 = "192.168.59.40";
      enx2-7.ipv4 = "192.168.59.136";
      enx2-8.ipv4 = "192.168.59.168";
      enx3-7.ipv4 = "192.168.59.142";
      enx3-8.ipv4 = "192.168.59.174";
    };

    x570.interfaces = {
      lo.ipv4 = "192.168.63.10";
      eno1.ipv4 = "192.168.49.10";
      eno2.ipv4 = "192.168.61.149";
      enx3.ipv4 = "192.168.61.129";
      enx4.ipv4 = "192.168.61.130";
      wlan1.ipv4 = "172.16.248.10";
      eno1-3.ipv4 = "192.168.59.7";
      eno1-4.ipv4 = "192.168.59.39";
      eno2-5.ipv4 = "192.168.59.71";
      eno2-6.ipv4 = "192.168.59.103";
      enx3-7.ipv4 = "192.168.59.135";
      enx3-8.ipv4 = "192.168.59.167";
      enx4-7.ipv4 = "192.168.59.141";
      enx4-8.ipv4 = "192.168.59.173";
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
