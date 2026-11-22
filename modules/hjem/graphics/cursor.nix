{ config, pkgs, ... }:
let
  package = pkgs.callPackage ../../../packages/nordzy-cursor-white { };
  # Theme directory under share/icons (and index.theme Name), not the package name.
  name = "Nordzy-cursors-white";
  theme = "${package}/share/icons/${name}";
in
{
  packages = [ package ];
  environment.sessionVariables = {
    XCURSOR_THEME = name;
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "Nordzy-hyprcursors-white";
    HYPRCURSOR_SIZE = "24";
  };
  files = {
    ".icons/default/index.theme".text = "[Icon Theme]\nInherits=${name}\n";
    ".Xresources".text = "Xcursor.theme: ${name}\nXcursor.size: 24\n";
    ".icons/${name}".source = theme;
  };
  xdg.data.files."icons/default/index.theme".text = config.files.".icons/default/index.theme".text;
  xdg.data.files."icons/${name}".source = theme;
}
