# First attempt at creating a VXLAN fabric
{config, pkgs, ...}: let
  vxl = config.networking.vxlan;
in {
  networking = {
    useNetworkd = true;
    vxlan.enable = true;
  };

  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = false;
    "net.bridge.bridge-nf-call-ip6tables" = false;
  };

  systemd.network.networks = {
    "vxlan100" = {
      matchConfig.Name = "vxlan100";
      networkConfig = {
        Bridge = "br100";
      };
    };

    "br100" = {
      matchConfig.Name = "br100";
      bridgeConfig = {};
    };
  };

  systemd.network.links = {
    "vxlan100" = {
      # matchConfig.MACAddress = "02:00:00:00:00:01"; # For eventual static assignment
      linkConfig = {
        Name = "vxlan100";
        MTUBytes = 1450;
      };
    };
  };

  systemd.services.vxlan-setup = {
    wantedBy = ["network-online.target"];
    path = [pkgs.iproute2];
    script = ''
      ip link add br100 type bridge
      ip link set br100 up
      ip link add vxlan100 type vxlan id 100 dstport ${toString vxl.port} dev eno1 group 239.1.1.100
      ip link set vxlan100 up
      ip link set vxlan100 master br100
    '';
  };
}
