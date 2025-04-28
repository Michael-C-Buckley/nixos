# Combine Cursor Definition/Aggregation Module
#  Single point of all cursor settings combined
{
  config,
  lib,
  user,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) package lines int str;

  local = config.home.features.${user}.cursor;
  theme = local.theme;
  size = toString local.size;
in {
  # Options the user will define for themselves
  options.home.features.${user}.cursor = {
    theme = mkOption {
      type = str;
      description = "Name of the cursor theme to use.";
    };
    size = mkOption {
      type = int;
      default = 24;
      description = "Cursor size.";
    };
    package = mkOption {
      type = package;
      description = "User's cursor package.";
    };

    # Info that will be implemented later via various methods
    #  including hjem versus home-manager
    #  as well as squashing options into their final file, like GTK
    _info = {
      gtk = mkOption {
        type = lines;
        internal = true;
        description = "Generated GTK cursor settings.";
        default = ''
          gtk-cursor-theme-name=${theme}
          gtk-cursor-theme-size=${size}
        '';
      };
      Xresources = mkOption {
        type = lines;
        internal = true;
        description = "Generated Xresources cursor settings.";
        default = ''
          Xcursor.theme: ${theme}
          Xcursor.size: ${size}
        '';
      };
      envVars = mkOption {
        type = lines;
        internal = true;
        description = "Generated environment variable settings.";
        default = ''
          XCURSOR_THEME=${theme}
          XCURSOR_SIZE=${size}
        '';
      };
      hyprcursor = mkOption {
        type = lines;
        internal = true;
        description = "Generated Hyprland cursor block.";
        default = ''
          cursor {
            theme = ${theme}
            size = ${size}
          }
        '';
      };
    };
  };
}
