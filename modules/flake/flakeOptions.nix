{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) attrs attrsOf deferredModule;
in {
  options.flake = {
    hjemConfig = mkOption {
      type = attrsOf deferredModule;
      default = {};
      description = "Hjem configuration modules to be included in the hjem user configuration.";
    };
    wrappers = mkOption {
      description = "Modules that can be called to created wrapped packages from this flake.";
    };
    hjemModules = mkOption {
      type = attrsOf deferredModule;
      default = {};
      description = "Hjem modules to be included in the hjem user configuration.";
    };
    lib = mkOption {
      type = attrs;
      default = {};
      description = "Library functions to be made available in this flake.";
    };
  };
}
