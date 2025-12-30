{config, ...}: let
  inherit (config.flake) wrappers;
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
      # Adding to the wrapper isn't enough, add it to the system
      environment.systemPackages = [pkgs.xwayland-satellite];
      programs = {
        # Niri itself will not be wrapped because UWSM will be
        niri = {
          enable = true;
          package = wrappers.mkNiri {
            inherit pkgs;
            useFlags = false;
          };
        };
        uwsm = {
          enable = true;
          waylandCompositors.niri = {
            prettyName = "Niri";
            comment = "Niri managed by UWSM and wrapped with my config";
            binPath = "/run/current-system/sw/bin/niri";
            extraArgs = ["-c" "${wrappers.mkNiriConfig {inherit pkgs extraConfig;}}"];
          };
        };
      };
    };
  };
}
