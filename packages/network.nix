{ config, pkgs, lib, ... }: let
  netTools = config.features.pkgs.netTools;
  pkgList = with pkgs; [
    # System
    ethtool
    nmap
    iperf
    tcpdump
    inetutils

    # L2
    vlan
    bridge-utils
    lldpd
    cdpr

    # L3
    ndisc6
    frr
    wireguard-tools

    # L4+
    dig
    nftables
  ];
in {
  users.users = {
    michael.packages = lib.optionals netTools pkgList;
    root.packages = lib.optionals netTools  pkgList;
  };
}
