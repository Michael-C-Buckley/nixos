{lib, ...}: {
  options.flake = {
    hjemConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = {};
      description = "Hjem configuration modules to be included in the hjem user configuration.";
    };
    lib = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Library functions to be made available in this flake.";
    };
  };
}
