{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.custom.routing = {
    routerId = mkOption {
      type = types.str;
      description = "Host's router ID";
    };
  };

  config = {
    networking.ospf.enable = true;

    services.frr = {
      bgpd.enable = true;
      bfdd.enable = true;
    };

    services.frr.config = ''
      ip forwarding
      ipv6 forwarding

      int lo
       ip ospf passive
       ip ospf area 0

      int eno1
       ip ospf area 0
    '';
  };
}
