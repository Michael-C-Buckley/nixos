# First attempt at creating a VXLAN fabric
{
  config,
  pkgs,
  ...
}: let
  vxl = config.networking.vxlan;
in {
  networking = {
    vxlan.enable = true;
  };

  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = false;
    "net.bridge.bridge-nf-call-ip6tables" = false;
  };

  # Create the bridge with systemd
  environment.etc = {
    "systemd/network/20-br100.netdev".text = ''
      [NetDev]
      Name=br100
      Kind=bridge
    '';
  };

  # Create and configure VXLAN with a service since NetDev was silently failing
  # Yet creating the bridge in the one-shot caused issues with timing
  systemd.services.vxlan-setup = {
    wantedBy = ["network-online.target"];
    path = [pkgs.iproute2];
    script = ''
      ip link add vxlan100 type vxlan id 100 dstport ${toString vxl.port} dev eno1 group 239.1.1.100
      ip link set vxlan100 master br100
      ip link set br100 up
      ip link set vxlan100 up
    '';
  };
}
