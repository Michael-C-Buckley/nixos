{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) bool int;

  vxl = config.networking.vxlan;
in {
  options.networking.vxlan = {
    enable = mkEnableOption "Enable VXLAN settings on this host";
    port = mkOption {
      type = int;
      default = 4789;
      description = "UDP port that VXLAN will use";
    };
    openFirewall = mkOption {
      type = bool;
      default = config.networking.vxlan.enable;
      description = "Open the Firewall for the VXLAN ports";
    };
  };

  config.networking = {
    firewall.allowedUDPPorts = mkIf vxl.openFirewall [vxl.port];
  };
}
