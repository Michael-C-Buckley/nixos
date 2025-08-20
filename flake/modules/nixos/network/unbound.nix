{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  local = config.services.unbound;
in {
  services.unbound = {
    # Keep non-sensitive settings here
    settings = {
      server = {
        hide-identity = mkDefault "yes";
        hide-version = mkDefault "yes";
        verbosity = 0;
      };
      include = config.sops.secrets.unboundLocal.path;
    };
  };

  # The secret is owned by root by default as it is a common secret
  sops.secrets.unboundLocal = mkIf local.enable {
    owner = "unbound";
    group = "unbound";
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
