{config, ...}: let
  inherit (config.flake) hosts;
  inherit (config.lib.network) getAddress;
in {
  flake.modules.nixos.network = {
    networking.hosts = {
      "192.168.48.1" = ["mt3" "mt3.michael.lan"];
      "192.168.48.2" = ["c9300" "c9300.michael.lan"];
      "192.168.48.3" = ["r8200" "r8200.michael.lan"];

      "192.168.48.20" = ["m1" "m1.michael.lan"];
      "${getAddress hosts.x570.interfaces.lo.ipv4}" = ["x570" "x570.michael.lan"];
      "${getAddress hosts.p520.interfaces.lo.ipv4}" = ["p520" "p520.michael.lan"];

      # 2.5GbE
      "${getAddress hosts.uff1.interfaces.enu2.ipv4}" = ["uff1s"];
      "${getAddress hosts.uff2.interfaces.enu2.ipv4}" = ["uff2s"];
      "${getAddress hosts.uff3.interfaces.enu2.ipv4}" = ["uff3s"];

      # Loopbacks
      "192.168.61.0" = ["uff" "uff.michael.lan"];
      "${getAddress hosts.uff1.interfaces.lo.ipv4}" = ["uff1" "uff1.michael.lan"];
      "${getAddress hosts.uff2.interfaces.lo.ipv4}" = ["uff2" "uff2.michael.lan"];
      "${getAddress hosts.uff3.interfaces.lo.ipv4}" = ["uff3" "uff3.michael.lan"];
      "${getAddress hosts.b550.interfaces.lo.ipv4}" = ["b550" "b550.michael.lan"];
    };
  };
}
