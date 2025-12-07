{config, ...}: let
  inherit (config.flake.hosts.b550.interfaces) lo eno1 enp3s0f0 enp3s0f1 br0;
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

      int enp3s0f0
        ip ospf cost 100

      int enp3s0f1
        ip ospf cost 100

      router ospf
        network ${lo.ipv4}/32 area 0
        network ${eno1.ipv4}/32 area 0
        network ${enp3s0f0.ipv4}/32 area 0
        network ${enp3s0f1.ipv4}/32 area 0
        network ${br0.ipv4}/32 area 0
        network 172.20.20.0/24 area 0
    '';
  };
}
