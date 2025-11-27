# I am a network engineer by trade so this entire family of modules will be
#  considerably more complex than most typical NixOS/Linux users
# I also DO NOT respect namespaces - Copy at your own risk
# You have been warned
{config, ...}: let
  inherit (config.flake) hosts modules;
in {
  flake.modules.nixos.network = {
    config,
    lib,
    ...
  }: let
    inherit (hosts.${config.networking.hostName}.interfaces) lo;
  in {
    # Bring in the rest of the routing protocol modules
    imports = with modules.nixos; [
      bgp
      eigrp
      ospf
      vrrp
      #vxlan # WIP and not included by default
    ];

    config = {
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
      };

      services = {
        lldpd.enable = lib.mkDefault true;
        # Set sane standards on file descriptor limits for FRR daemons
        frr = {
          bgpd.options = ["--limit-fds 2048"];
          zebra.options = ["--limit-fds 2048"];
          openFilesLimit = 2048;
        };
        iperf3.openFirewall = config.services.iperf3.enable;
      };

      # Apply the loopback address if added
      networking.interfaces.lo.ipv4.addresses = lib.optionals (lo.ipv4 != null || lo.ipv4 != "") [
        {
          address = lo.ipv4;
          prefixLength = 32;
        }
      ];
    };
  };
}
