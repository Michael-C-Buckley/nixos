{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) int enum nullOr;
  inherit (config.networking) ospf loopback;

  originate =
    if ospf.defaultRoute.metric != null
    then "default-information originate metric ${builtins.toString ospf.defaultRoute.metric} metric-type ${builtins.toString ospf.defaultRoute.metricType}"
    else "";
in {
  options.networking.ospf = {
    enable = mkEnableOption "Enable OSPF and allow protocol 89";
    defaultRoute = {
      metricType = mkOption {
        type = enum [1 2];
        default = null;
        description = "OSPF External metric type [1 or 2].";
      };
      metric = mkOption {
        type = nullOr int;
        default = null;
        description = "OSPF metric for the external route.";
      };
    };
  };
  config = mkIf ospf.enable {
    services.frr = {
      ospfd.enable = true;
      config =
        ''
          router ospf
            router-id ${loopback.ipv4}
        ''
        + originate;
    };
    networking.firewall.extraInputRules = ''
      ip protocol 89 accept comment "Allow OSPF"
    '';
  };
}
