{config, ...}: {
  flake.custom.hjemConfigs.kitty = {pkgs, ...}: {
    # For linking my config, such as on Mac if using brew
    hjem.users.michael.xdg.config.files."kitty/kitty.conf" = {
      source = config.flake.custom.wrappers.mkKittyConfig {inherit pkgs;};
      type = "copy";
      permissions = "0644";
    };
  };
}
