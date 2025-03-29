# This contains a function to produce a Wireguard Systemd Unit
# 2-stage function for import to and through a flake into a config
_: {lib}: cidr: let
  parts = builtins.split "/" cidr;
in {
  address = builtins.elemAt parts 0;
  prefixLength = lib.strings.toInt (builtins.elemAt parts 1);
}
