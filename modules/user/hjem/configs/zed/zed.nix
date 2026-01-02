# Zed is changing their config schema a bunch,
# so mutably link an initial state to prevent issues
# with not being able to have them convert the config
let
  mkMutable = source: {
    inherit source;
    type = "copy";
    permissions = "0644";
  };
in {
  flake.hjemConfigs.zed = {
    hjem.users.michael = {
      files = {
        ".config/zed/settings.json" = mkMutable ./settings.json;
        ".config/zed/keymap.json" = mkMutable ./keymap.json;
      };
    };
  };
}
