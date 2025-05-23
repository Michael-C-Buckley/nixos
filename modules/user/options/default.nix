{lib, ...}: let 
  inherit (lib) mkOption;
  inherit (lib.types) attrs package listOf;
in {
  imports = [
    ./system/impermanence.nix
  ];

  options = {
    packageList = mkOption {
      type = listOf package;
      default = [];
      description = "Declared user packages.";
    };
    fileList = mkOption {
      type = attrs;
      default = {};
      description = "The full list of user space files ready to be linked.";
    };
  };
}
