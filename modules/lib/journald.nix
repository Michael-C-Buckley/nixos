{lib, ...}: {
  flake.custom.lib = {
    # Change the logging of a list of units to the specified journal namespace
    mkJournalNamespace = namespace: units:
      builtins.listToAttrs (map (x: {
          name = x;
          value = {serviceConfig.LogNamespace = namespace;};
        })
        units);

    # Populate
    mkJournalEtcFile = namespace: ''
      [Journal]
      Storage=${namespace.storage}
      SystemMaxUse=${namespace.systemMaxUse}
      SystemMaxFileSize=${namespace.systemMaxFileSize}
      RuntimeMaxUse=${namespace.runtimeMaxUse}
    '';

    # Return the common set of journal options
    mkJournalOptions = {
      storage = lib.mkOption {
        type = lib.types.str; # TODO: Eventually move to enum
        default = "persistent";
        description = "Journald storage option.";
      };
      systemMaxUse = lib.mkOption {
        type = lib.types.str;
        default = "1280M"; # 10x the default file size
        description = "Max system usage of the default journald namespace.";
      };
      runtimeMaxUse = lib.mkOption {
        type = lib.types.str;
        default = "128M"; # Matched to default file size
        description = "Max runtime usage (for volatile) of the default journald namespace.";
      };
      systemMaxFileSize = lib.mkOption {
        type = lib.types.str;
        default = "128M"; # Also coincides with the Journald default
        description = "Max filesize of the default journald namespace.";
      };
    };
  };
}
