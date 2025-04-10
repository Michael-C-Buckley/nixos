{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption;
  bgp = config.networking.bgp;
in {
  options.networking.bgp = {
    enable = mkEnableOption "Enable BGP and allow the default port";
    port = mkOption {
      type = lib.types.int;
      default = 179;
      description = "BGP Listen Port";
    };
  };
  config = mkIf bgp.enable {
    services.frr.bgpd.enable = mkDefault true;
    networking.firewall.allowedTCPPorts = [bgp.port];
  };
}
