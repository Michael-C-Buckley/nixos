{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str nullOr;
in {
  options.networking = {
    loopback = {
      ipv4 = mkOption {
        type = nullOr str;
        default = null;
        description = "Additional IPv4 address to add to loopback.";
      };
    };
  };
}
