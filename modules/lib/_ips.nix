{lib, ...}: {
  parseCIDR = cidr: let
    parts = builtins.split "/" cidr;
  in {
    address = builtins.elemAt parts 0;
    prefixLength = lib.toInt (builtins.elemAt parts 2);
  };
}
