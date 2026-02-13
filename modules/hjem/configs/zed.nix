# Zed is changing their config schema a bunch,
# so mutably link an initial state to prevent issues
# with not being able to have them convert the config
{config, ...}: {
  flake.hjemConfigs.zed = {
    hjem.users.michael.xdg.config.files."zed/settings.json" = {
      text = config.flake.wrappers.mkZedConfig {};
      type = "copy";
      permissions = "0644";
    };
  };
}
