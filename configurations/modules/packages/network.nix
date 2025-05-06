{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  inherit (builtins) elem;
  basePkgs = with pkgs; [
    nmap
    iperf
    tcpdump
    inetutils
    frr
    wireguard-tools
    dig
  ];
  extraPkgs = with pkgs; [
    ethtool
    vlan
    bridge-utils
    lldpd
    cdpr
  ];

  useExtra = elem config.system.preset ["laptop" "server" "desktop"];

  networkPkgs = basePkgs ++ optionals useExtra extraPkgs;
in {
  users.users = {
    root.packages = networkPkgs;
  };
}
