{config, ...}: let
  inherit (config.flake.custom.wrappers) mkGhosttyConfig;
in {
  flake.custom.hjemConfigs.ghostty = {
    pkgs,
    config,
    ...
  }: {
    # For linking my config, such as on Mac if using brew
    hjem.users.${config.custom.hjem.username}.xdg.config.files."ghostty/config" = {
      source = mkGhosttyConfig {inherit pkgs;};
      type = "copy";
      permissions = "0644";
    };
  };
}
