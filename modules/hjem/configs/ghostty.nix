{config, ...}: {
  flake.custom.hjemConfigs.ghostty = {pkgs, ...}: {
    # For linking my config, such as on Mac if using brew
    hjem.users.michael.xdg.config.files."ghostty/config" = {
      source = config.flake.custom.wrappers.mkGhosttyConfig {inherit pkgs;};
      type = "copy";
      permissions = "0644";
    };
  };
}
