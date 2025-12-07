{config, ...}: let
  inherit (config.flake.hosts.b550.interfaces) lo eno1 enp2 enp3 enp4 br0;
in {
  # This host uses network statements since I also use ContainerLab and advertise
  # the IPs to reach the nodes, which creates an emphereal bridge with a changing
  # name, so network statements match it much better
  flake.modules.nixos.b550 = {
    services.frr.config = ''
      ip forwarding

      int lo
        ip ospf passive

      int br0
        ip ospf passive

      int eno1
        ip ospf cost 1000

      int enp2
        ip ospf cost 400

      int enp3
        ip ospf cost 100

      int enp4
        ip ospf cost 100

      router ospf
        network ${lo.ipv4}/32 area 0
        network ${eno1.ipv4}/32 area 0
        network ${enp2.ipv4}/32 area 0
        network ${enp3.ipv4}/32 area 0
        network ${enp4.ipv4}/32 area 0
        network ${br0.ipv4}/32 area 0
        network 172.20.20.0/24 area 0
    '';
  };
}
