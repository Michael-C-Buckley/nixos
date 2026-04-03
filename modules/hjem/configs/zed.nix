# Zed is changing their config schema a bunch,
# so mutably link an initial state to prevent issues
# with not being able to have them convert the config
{config, ...}: {
  flake.custom.hjemConfigs.zed = {pkgs, ...}: {
    hjem.users.michael.xdg.config.files."zed/settings.json" = {
      source = config.flake.custom.wrappers.mkZedConfig {inherit pkgs;};
      type = "copy";
      permissions = "0644";
    };
  };
}
