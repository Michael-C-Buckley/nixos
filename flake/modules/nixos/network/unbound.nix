{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  services.unbound = {
    # Keep non-sensitive settings here
    settings = {
      server = {
        interface = mkDefault ["127.0.0.1" "::1"];
        access-control = mkDefault ["127.0.0.0/8 allow" "::1/128 allow"];
        hide-identity = mkDefault "yes";
        hide-version = mkDefault "yes";
        verbosity = 0;
      };
      include = config.sops.secrets.unboundLocal.path;
    };
  };

  networking = mkIf config.services.unbound.enable {
    nameservers = [
      "127.0.0.1"
      "::1"
      "1.1.1.1"
      "9.9.9.9"
    ];
  };
}
