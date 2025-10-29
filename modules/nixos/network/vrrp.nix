# Currently completely broken on the FRR side
# https://github.com/FRRouting/frr/issues/18379
{
  flake.modules.nixos.vrrp = {config, ...}: {
    services.keepalived.enable = true;
    networking.firewall =
      if config.networking.nftables.enable
      then {
        extraInputRules = ''
          ip protocol 112 accept comment "Allow VRRP"
        '';
      }
      else {
        extraCommands = ''
          iptables -A nixos-fw -p 112 -j ACCEPT -m comment --comment "Allow VRRP"
        '';
      };
  };
}
