{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) attrs attrsOf deferredModule;
in {
  options.flake = {
    hjemModules = mkOption {
      type = attrsOf deferredModule;
      default = {};
      description = "Hjem modules to be included in the hjem user configuration.";
    };
    hjemConfigs = mkOption {
      type = attrsOf deferredModule;
      default = {};
      description = "Hjem configurations with specific options set, usually per-user.";
    };
    lib = mkOption {
      type = attrs;
      default = {};
      description = "Library functions to be made available in this flake.";
    };
    packageLists = mkOption {
      description = "Commonly reused package lists, they are lists of strings found in nixpkgs that will be transformed given `pkgs` reference.";
    };
    wrappers = mkOption {
      description = "Modules that can be called to created wrapped packages from this flake.";
    };
  };
}
