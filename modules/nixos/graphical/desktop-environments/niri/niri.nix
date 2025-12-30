{config, ...}: let
  inherit (config.flake.wrappers) mkNiri;
in {
  flake.modules.nixos.niri = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.custom.niri.extraConfig = lib.mkOption {
      description = "Instance-specific options that gets sent to the wrapper function.";
      type = lib.types.lines;
      default = '''';
    };

    config = let
      extraConfig =
        config.custom.niri.extraConfig
        # Add session variable inheriting
        + ''
          spawn-sh-at-startup "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY"
          spawn-sh-at-startup "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY"
        '';
    in {
      custom.noctalia.parent = "niri.service";

      programs.niri = {
        enable = true;
        package = mkNiri {
          inherit pkgs extraConfig;
          spawnNoctalia = false;
        };
      };
    };
  };
}
