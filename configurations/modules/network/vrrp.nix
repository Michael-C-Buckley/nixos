{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  vrrp = config.networking.vrrp;
in {
  options.networking = {
    vrrp.enable = mkEnableOption "Enable VRRP and allow protocol 112";
  };
  config = mkIf vrrp.enable {
    services.frr.vrrpd.enable = true;
    networking.firewall.extraInputRules = ''
      ip protocol 112 accept comment "Allow VRRP"
    '';
  };
}
