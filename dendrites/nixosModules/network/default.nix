# I am a network engineer by trade so this entire family of modules will be
#  considerably more complex than most typical NixOS/Linux users
# I also DO NOT respect namespaces - Copy at your own risk
# You have been warned
{
  flake.modules.nixos.network.default = {
    config,
    lib,
    ...
  }: let
    inherit (lib) mkDefault optionals;
    inherit (config.networking) loopback;
    inherit (lib) mkOption;
    inherit (lib.types) str nullOr;

    addr = addr: prefix: {
      address = addr;
      prefixLength = prefix;
    };
  in {
    options.networking = {
      loopback = {
        ipv4 = mkOption {
          type = nullOr str;
          default = null;
          description = "Additional IPv4 address to add to loopback.";
        };
      };
    };

    config = {
      # WIP: Do I want to import the dendrites?
      # LEGACY - I imported all components together and shipped a networking bundle
      # imports = [
      #   ./bgp.nix
      #   ./eigrp.nix
      #   ./ospf.nix
      #   ./unbound.nix
      #   ./vrrp.nix
      #   ./vxlan.nix
      # ];

      services = {
        lldpd.enable = mkDefault true;
        # Set sane standards on file descriptor limits for FRR daemons
        frr = {
          bgpd.options = mkDefault ["--limit-fds 2048"];
          zebra.options = mkDefault ["--limit-fds 2048"];
          openFilesLimit = mkDefault 2048;
        };
        iperf3.openFirewall = config.services.iperf3.enable;
      };

      # Apply the loopback address if added
      networking.interfaces.lo.ipv4.addresses = optionals (loopback.ipv4 != null) [
        (addr loopback.ipv4 32)
      ];
    };
  };
}
