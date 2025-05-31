{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) int enum nullOr;
  ospf = config.networking.ospf;
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
      config = mkIf (ospf.defaultRoute.metric != null) ''
        router ospf
          default-information originate metric ${builtins.toString ospf.defaultRoute.metric} metric-type ${builtins.toString ospf.defaultRoute.metricType}
      '';
    };
    networking.firewall.extraInputRules = ''
      ip protocol 89 accept comment "Allow OSPF"
    '';
  };
}
