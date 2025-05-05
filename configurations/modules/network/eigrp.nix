{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  eigrp = config.networking.eigrp;
in {
  options.networking = {
    eigrp.enable = mkEnableOption "Enable EIGRP and allow protocol 88";
  };
  config = mkIf eigrp.enable {
    services.frr.eigrpd.enable = true;
    networking.firewall.extraInputRules = ''ip protocol 88 accept comment "Allow EIGRP"'';
  };
}
