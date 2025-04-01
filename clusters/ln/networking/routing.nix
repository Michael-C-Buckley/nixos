{config, lib, ...}: let
  inherit (lib) mkForce mkOption types;
  cfg = config.custom.routing;
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

    environment.etc."frr/frr.conf".text = mkForce ''
        ip forwarding

        router ospf
          router-id ${cfg.routerId}

        int lo
         ip ospf passive
         ip ospf area 0

        int eno1
         ip ospf area 0
    '';
    };
}
