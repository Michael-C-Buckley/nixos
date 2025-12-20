{
  flake.packageLists.network = [
    # HTTP/Web
    "curl"
    "wget"
    "dig"

    # Hardware
    "ethtool"
    "tcpdump"
    "net-tools"
    "unixtools.arp"
    "unixtools.netstat"
    "iperf3"

    # Layer 2
    "bridge-utils"
    "cdpr"
    "lldpd"
    "vlan"

    # Layer 3
    "dhcpcd"
    "frr"
    "inetutils"
    "ndisc6"

    # Security
    "nmap"
    "wireguard-tools"
  ];
}
