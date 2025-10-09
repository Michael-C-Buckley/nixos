{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.networking) eigrp;
in {
  options.networking = {
    eigrp.enable = mkEnableOption "Enable EIGRP and allow protocol 88";
  };
  config = mkIf eigrp.enable {
    services.frr.eigrpd.enable = true;
    networking.firewall.extraInputRules = ''
      ip protocol 88 accept comment "Allow EIGRP"
    '';
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p 88 -j ACCEPT -m comment --comment "Allow EIGRP"
    '';
  };
}
