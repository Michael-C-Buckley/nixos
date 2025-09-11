# Combine Cursor Definition/Aggregation Module
#  Single point of all cursor settings combined
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) package lines int str attrs;

  local = config.appearance.cursor;
  size = toString local.size;
in {
  # Options the user will define for themselves
  options.appearance.cursor = {
    manage = mkEnableOption "Declaratively manage cursor settings.";
    xtheme = mkOption {
      type = str;
      description = "Name of the xcursor theme to use.";
    };
    hyprtheme = mkOption {
      type = str;
      description = "Name of the hyprcursor theme to use.";
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
    _files = mkOption {
      type = attrs;
      internal = true;
      description = "Prepared files for the cursor ready for linking.";
      default = {
        ".config/.Xresources".text = local._info.Xresources;
      };
    };
    _info = {
      gtk = mkOption {
        type = lines;
        internal = true;
        description = "Generated GTK cursor settings.";
        default = ''
          gtk-cursor-theme-name=${local.xtheme}
          gtk-cursor-theme-size=${size}
        '';
      };
      Xresources = mkOption {
        type = lines;
        internal = true;
        description = "Generated Xresources cursor settings.";
        default = ''
          Xcursor.theme: ${local.xtheme}
          Xcursor.size: ${size}
        '';
      };
      envVars = mkOption {
        type = lines;
        internal = true;
        description = "Generated environment variable settings.";
        default = ''
          XCURSOR_THEME=${local.theme}
          XCURSOR_SIZE=${size}
        '';
      };
      hyprcursor = mkOption {
        type = lines;
        internal = true;
        description = "Generated Hyprland cursor block.";
        default = ''
          cursor {
            theme = ${local.hyprtheme}
            size = ${size}
          }
        '';
      };
    };
  };
  config = mkIf local.manage {
    fileList = local._files;
    packageList = [local.package];
  };
}
