{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault;
  ospf = config.networking.ospf;
in {
  options.networking = {
    ospf.enable = mkEnableOption "Enable OSPF and allow protocol 89";
  };
  config = {
    # Enable and allow OSPF
    services.frr.ospfd.enable = mkDefault ospf.enable;
    networking.firewall.extraInputRules = ''ip protocol 89 accept comment "Allow OSPF"'';
  };
}
