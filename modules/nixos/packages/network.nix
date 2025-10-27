{
  flake.modules.nixos.packages-network = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      curl
      wget
      bridge-utils
      cdpr
      dhcpcd
      dig
      ethtool
      frr
      inetutils
      iperf3
      lldpd
      ndisc6
      net-tools
      nmap
      tcpdump
      unixtools.arp
      unixtools.netstat
      vlan
      wireguard-tools
    ];
  };
}
