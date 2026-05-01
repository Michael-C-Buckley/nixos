{config, ...}: let
  inherit (config.flake.custom.wrappers) mkGhosttyConfig;
in {
  flake.custom.hjemConfigs.ghostty = {pkgs, ...}: {
    # For linking my config, such as on Mac if using brew
    hjem.users.michael.xdg.config.files."ghostty/config" = {
      source = mkGhosttyConfig {inherit pkgs;};
      type = "copy";
      permissions = "0644";
    };
  };
}
