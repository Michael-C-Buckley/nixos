{lib, ...}: {
  options.flake = {
    hjemConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = {};
      description = "Hjem configuration modules to be included in the hjem user configuration.";
    };
  };
}
