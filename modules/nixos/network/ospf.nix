{config, ...}: let
  inherit (config.flake) hosts;
in {
  flake.modules.nixos.ospf = {
    config,
    lib,
    ...
  }: let
    inherit (config.networking) ospf hostName;
    inherit (hosts.${hostName}.interfaces) lo;

    originate =
      if ospf.defaultRoute.metric != null
      then "default-information originate metric ${builtins.toString ospf.defaultRoute.metric} metric-type ${builtins.toString ospf.defaultRoute.metricType}\n"
      else "";

    routerId =
      if lo.ipv4 != null
      then "router-id ${lo.ipv4}\n"
      else "";
  in {
    options.networking.ospf = {
      defaultRoute = {
        metricType = lib.mkOption {
          type = lib.types.enum [1 2];
          default = null;
          description = "OSPF External metric type [1 or 2].";
        };
        metric = lib.mkOption {
          type = with lib.types; nullOr int;
          default = null;
          description = "OSPF metric for the external route.";
        };
      };
    };
    config = {
      services.frr = {
        ospfd.enable = true;
        config = "router ospf\n" + routerId + originate;
      };
      networking.firewall =
        if config.networking.nftables.enable
        then {
          extraInputRules = ''
            ip protocol 89 accept comment "Allow OSPF"
          '';
        }
        else {
          extraCommands = ''
            iptables -A nixos-fw -p 89 -j ACCEPT -m comment --comment "Allow OSPF"
          '';
        };
    };
  };
}
