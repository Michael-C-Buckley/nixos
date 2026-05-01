{config, ...}: let
  inherit (config.flake.custom.wrappers) mkKittyConfig;
in {
  flake.custom.hjemConfigs.kitty = {pkgs, ...}: {
    # For linking my config, such as on Mac if using brew
    hjem.users.michael.xdg.config.files."kitty/kitty.conf" = {
      source = mkKittyConfig {inherit pkgs;};
      type = "copy";
      permissions = "0644";
    };
  };
}
