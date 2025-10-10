{
  flake.modules.nixosModules.unbound = {config, ...}: {
    services.unbound = {
      # Keep non-sensitive settings here
      settings = {
        server = {
          hide-identity = "yes";
          hide-version = "yes";
          verbosity = 0;
        };
        include = config.sops.secrets.unboundLocal.path;
      };
    };

    # The secret is owned by root by default as it is a common secret
    sops.secrets.unboundLocal = {
      owner = "unbound";
      group = "unbound";
    };

    networking = {
      # Use localhost (via Unbound) or common others if it fails
      nameservers = [
        "127.0.0.1"
        "::1"
        "1.1.1.1"
        "9.9.9.9"
      ];
    };
  };
}
