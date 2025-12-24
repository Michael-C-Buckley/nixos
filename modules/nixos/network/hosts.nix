{config, ...}: let
  inherit (config.flake) hosts;
  inherit (config.flake.lib.network) getAddress;

  a = host: interface: getAddress hosts.${host}.interfaces.${interface}.ipv4;
in {
  flake.modules.nixos.network = {
    networking.hosts = {
      "192.168.48.1" = ["mt3" "mt3.michael.lan"];
      "192.168.48.2" = ["c9300" "c9300.michael.lan"];
      "192.168.48.3" = ["r8200" "r8200.michael.lan"];
      "192.168.48.20" = ["m1" "m1.michael.lan"];

      # 2.5GbE
      "${a "uff1" "enu2"}" = ["uff1s"];
      "${a "uff2" "enu2"}" = ["uff2s"];
      "${a "uff3" "enu2"}" = ["uff3s"];

      # Loopbacks
      "192.168.61.0" = ["uff" "uff.michael.lan"];
      "${a "uff1" "lo"}" = ["uff1" "uff1.michael.lan"];
      "${a "uff2" "lo"}" = ["uff2" "uff2.michael.lan"];
      "${a "uff3" "lo"}" = ["uff3" "uff3.michael.lan"];
      "${a "b550" "lo"}" = ["b550" "b550.michael.lan"];
      "${a "x570" "lo"}" = ["x570" "x570.michael.lan"];
      "${a "p520" "lo"}" = ["p520" "p520.michael.lan"];

      # VMs and other services
      "192.168.56.2" = ["cml" "cml.michael.lan"];
      "192.168.56.34" = ["cs9800" "wlc.michael.lan"];
    };
  };
}
