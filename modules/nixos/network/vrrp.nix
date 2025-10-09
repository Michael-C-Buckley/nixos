# Currently completely broken on the FRR side
# https://github.com/FRRouting/frr/issues/18379
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.networking) vrrp;
in {
  options.networking = {
    vrrp.enable = mkEnableOption "Enable VRRP (via keepalived) and allow protocol 112";
  };
  config = mkIf vrrp.enable {
    services.keepalived.enable = true;
    networking.firewall.extraInputRules = ''
      ip protocol 112 accept comment "Allow VRRP"
    '';
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p 112 -j ACCEPT -m comment --comment "Allow VRRP"
    '';
  };
}
