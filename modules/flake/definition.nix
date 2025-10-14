{lib, ...}: {
  options.flake = {
    hjemConfigurations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule []);
      default = {};
      description = "Hjem configurations for outputs";
    };
  };
}
