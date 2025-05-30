# GTK Appearance Module
#  NOTE: Cursors are handled on their on in `../cursor`
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) package lines str attrs;

  userCfg = config.appearance;
  local = userCfg.gtk;
in {
  options.appearance.gtk = {
    manage = mkEnableOption "Declaratively manage GTK settings.";
    theme = {
      name = mkOption {
        type = str;
        description = "Name of the GTK theme to use.";
      };
      package = mkOption {
        type = package;
        description = "User's GTK theme package.";
      };
    };
    iconTheme = {
      name = mkOption {
        type = str;
        description = "Name of the GTK icon theme theme to use.";
      };
      package = mkOption {
        type = package;
        description = "User's GTK icon theme package.";
      };
    };

    # Info that will be implemented later via various methods
    #  including hjem versus home-manager
    #  as well as squashing options into their final file, like GTK
    _info = mkOption {
      type = lines;
      internal = true;
      description = "Generated GTK cursor settings.";
      default = ''
        gtk-theme-name=${local.theme.name}
        gtk-icon-theme-name=${local.iconTheme.name}
      '';
    };
    # The GTK ini file builder
    _file = mkOption {
      type = lines;
      internal = true;
      description = "Generated GTK file lines ready for linking.";
      default = ''
        # Generated by Nix
        [Settings]
        ${local._info}
        ${userCfg.cursor._info.gtk}
      '';
    };
    _envfile = mkOption {
      type = lines;
      internal = true;
      description = "Generated GTK file for environment.d for linking.";
      default = ''
        # Generated by Nix system config
        GTK_THEME=${local.theme.name}
      '';
    };
    # The prepared attrset for GTK theme items
    _files = mkOption {
      type = attrs;
      internal = true;
      description = "Set of files ready to be linked.";
      default = {
        ".config/gtk-3.0/settings.ini".text = local._file;
        ".config/gtk-4.0/settings.ini".text = local._file;
        ".config/environment.d/20-gtk.conf".text = local._envfile;
      };
    };
  };
  config = mkIf local.manage {
    fileList = local._files;
    packageList = [
      local.theme.package
      local.iconTheme.package
    ];
  };
}
