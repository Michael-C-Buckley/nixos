{lib, ...}: {
  options.flake = {
    hjemConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = {};
      description = "Hjem configuration modules to be included in the hjem user configuration.";
    };
    wrappers = lib.mkOption {
      description = "Modules that can be called to created wrapped packages from this flake.";
    };
    lib = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Library functions to be made available in this flake.";
    };
  };
}
