# Interim Options
{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf attrs package;
in {
  options = {
    fileList = mkOption {
      type = attrs;
      default = {};
      description = "The full list of user space files ready to be linked.";
    };
    packageList = mkOption {
      type = listOf package;
      default = [];
      description = "Declared user packages.";
    };
  };
}
