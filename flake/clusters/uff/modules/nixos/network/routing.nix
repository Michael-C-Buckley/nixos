{
  config,
  lib,
  ...
}: let
  inherit (lib) filter mkDefault;
  inherit (lib.strings) concatMapStringsSep;
  lo = config.networking.loopback.ipv4;

  # Exclude the current host from the neighbors
  neighbors =
    concatMapStringsSep "\n" (
      n: "neighbor ${n} peer-group fabric"
    ) (filter (n: n != lo) [
      # UFFs
      "192.168.61.1"
      "192.168.61.2"
      "192.168.61.3"
      # SFFs (OOS)
      #"192.168.61.5"
      #"192.168.61.6"
      #"192.168.61.7"
    ]);
in {
  networking = {
    bgp.enable = true;
    ospf.enable = true;
    vrrp.enable = true;
  };

  services = {
    keepalived.vrrpInstances.wan = {
      state = mkDefault "BACKUP";
      interface = "eno1";
      virtualRouterId = 1;
      virtualIps = [{addr = "192.168.48.30/24";}];
    };
    frr = {
      bfdd.enable = true;
      bgpd.enable = true;
      ospf6d.enable = true;
      vrrpd.enable = false;

      config = ''
        ip forwarding
        ipv6 forwarding
        router ospf
         router-id ${lo}
        int lo
         ip ospf area 0
         ip ospf passive
        int eno1
         ip ospf area 0
         ip ospf cost 400
         uo
        int enusb1
         ip ospf area 0
         ip ospf cost 100

        router bgp 65101
         bgp router-id ${lo}
         no bgp default ipv4-unicast

         neighbor fabric peer-group
         neighbor fabric update-source ${lo}
         neighbor fabric remote-as 65101
         ${neighbors}

         address-family l2vpn evpn
          neighbor fabric activate
          advertise-all-vni
        exit-address-family
      '';
    };
  };
}
