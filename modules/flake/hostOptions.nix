# Options used in NixOS hosts
{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str nullOr attrsOf submodule listOf;
in {
  options = {
    hosts = mkOption {
      type = attrsOf (submodule {
        options = {
          aliases = mkOption {
            type = listOf str;
            default = [];
            description = "Additional hostnames/aliases for this host.";
          };

          interfaces = mkOption {
            type = attrsOf (submodule {
              options = {
                ipv4 = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "IPv4 address for this interface.";
                };

                ipv6 = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "IPv6 address for this interface.";
                };
              };
            });
            default = {};
            description = "Interface-specific IP addresses.";
          };
        };
      });
      default = {};
      description = "Host IP mappings for hosts file generation and routing configuration.";
    };
  };
}
