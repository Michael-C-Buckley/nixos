{
  config,
  lib,
  user,
  ...
}: let
  cfg = config.home.features.${user};
in {
  imports = [
    (import ./appearance/cursor.nix {inherit config lib user;})
    (import ./appearance/gtk.nix {inherit config lib user;})
  ];

  options.home.features.${user}.fileList = lib.mkOption {
    type = lib.types.attrs;
    internal = true;
    description = "The full list of user space files ready to be linked.";

    # Merge all the defined files together
    default = cfg.cursor._files // cfg.gtk._files;
  };
}
