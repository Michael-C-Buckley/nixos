{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.system) preset;
  useMod = preset == "desktop" || preset == "laptop";
in {
  config = lib.mkIf useMod {
    environment.systemPackages = with pkgs; [
      materia-theme
      gruvbox-dark-icons-gtk
    ];
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Materia-dark";
            icon-theme = "Gruvbox Dark";
            font-name = "Sans Regular 11";
            document-font-name = "Sans Regular 11";
            monospace-font-name = "Monospace Regular 12";
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };
}
