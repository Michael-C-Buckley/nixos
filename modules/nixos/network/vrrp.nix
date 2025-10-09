# Currently completely broken on the FRR side
# https://github.com/FRRouting/frr/issues/18379
{
  flake.modules.nixosModules.vrrp = {
    services.keepalived.enable = true;
    networking.firewall.extraInputRules = ''
      ip protocol 112 accept comment "Allow VRRP"
    '';
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p 112 -j ACCEPT -m comment --comment "Allow VRRP"
    '';
  };
}
