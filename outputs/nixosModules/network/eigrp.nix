{
  flake.modules.nixos.eigrp = {config, ...}: {
    services.frr.eigrpd.enable = true;

    networking.firewall =
      if config.networking.nftables.enable
      then {
        extraInputRules = ''
          ip protocol 88 accept comment "Allow EIGRP"
        '';
      }
      else {
        extraCommands = ''
          iptables -A nixos-fw -p 88 -j ACCEPT -m comment --comment "Allow EIGRP"
        '';
      };
  };
}
