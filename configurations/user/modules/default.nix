{
  config,
  lib,
  user,
  ...
}: let
  cfg = config.features.${user};
  inherit (lib) mkOption;
  inherit (lib.types) attrs listOf package;
in {
  imports = [
    (import ./appearance/cursor.nix {inherit config lib user;})
    (import ./appearance/gtk.nix {inherit config lib user;})
  ];

  options.features.${user} = {
    fileList = mkOption {
      type = attrs;
      internal = true;
      description = "The full list of user space files ready to be linked.";

      # Merge all the defined files together
      default = cfg.cursor._files // cfg.gtk._files;
    };
    packageList = mkOption {
      type = listOf package;
      internal = true;
      description = "The package list for the user.";
      default = [];
    };
  };
}
