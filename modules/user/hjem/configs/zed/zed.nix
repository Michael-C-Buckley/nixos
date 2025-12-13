# Zed is changing their config schema a bunch,
# so mutably link an initial state to prevent issues
# with not being able to have them convert the config
let
  mkMutable = source: {
    inherit source;
    type = "copy";
    permissions = "0644";
  };
in
  {config, ...}: {
    flake.hjemConfig.zed = {pkgs, ...}: {
      hjem.users.michael = {
        files = {
          ".config/zed/settings.json" = mkMutable ./settings.json;
          ".config/zed/keymap.json" = mkMutable ./keymap.json;
        };
        # Use the path-wrapped Zed from this flake
        packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.zeditor];
      };
    };
  }
