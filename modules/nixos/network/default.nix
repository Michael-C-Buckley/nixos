# I am a network engineer by trade so this entire family of modules will be
#  considerably more complex than most typical NixOS/Linux users
# I also DO NOT respect namespaces - Copy at your own risk
# You have been warned
{
  flake.modules.nixosModules.network = {
    config,
    lib,
    ...
  }: let
    inherit (config.networking) loopback;

    addr = addr: prefix: {
      address = addr;
      prefixLength = prefix;
    };
  in {
    options.networking = {
      loopback = {
        ipv4 = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = "Additional IPv4 address to add to loopback.";
        };
      };
    };
    config = {
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
      networking.interfaces.lo.ipv4.addresses = lib.optionals (loopback.ipv4 != null) [
        (addr loopback.ipv4 32)
      ];
    };
  };
}
