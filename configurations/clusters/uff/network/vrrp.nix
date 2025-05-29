{pkgs, ...}: {
    systemd.services.vrrp-setup = {
    wantedBy = ["network-online.target"];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [pkgs.iproute2];
    script = ''
      set -euxo pipefail

      # Clean up old instance if it exists
      ip link show vrrp1 &> /dev/null && ip link delete vrrp1 || true

      # Create and configure the device
      ip link add vrrp1 link eno1 type macvlan mode bridge
      ip link set dev vrrp1 address 00:00:5e:00:01:01
      ip address add 192.168.48.100/24 dev vrrp1
      ip link set up vrrp1
    '';
  };

  services.frr.config = ''
    int eno1
      vrrp 1 version 3
      vrrp 1 ip 192.168.48.100
  '';
}
