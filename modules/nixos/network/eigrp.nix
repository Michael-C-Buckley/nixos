{
  flake.nixosModules.eigrp = {
    services.frr.eigrpd.enable = true;

    # These commands are for each implementation of the firewall
    networking.firewall.extraInputRules = ''
      ip protocol 88 accept comment "Allow EIGRP"
    '';
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p 88 -j ACCEPT -m comment --comment "Allow EIGRP"
    '';
  };
}
