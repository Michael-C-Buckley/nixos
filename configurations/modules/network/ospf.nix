{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  ospf = config.networking.ospf;
in {
  options.networking = {
    ospf.enable = mkEnableOption "Enable OSPF and allow protocol 89";
  };
  config = mkIf ospf.enable {
    services.frr.ospfd.enable = true;
    networking.firewall.extraInputRules = ''
      ip protocol 89 accept comment "Allow OSPF"
    '';
  };
}
