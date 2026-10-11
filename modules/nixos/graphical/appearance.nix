{ pkgs, ... }:
let
  gtkSettings = ''
    [Settings]
    gtk-theme-name=adw-gtk3-dark
    gtk-icon-theme-name=Adwaita
    gtk-font-name=DejaVu Sans 11
    gtk-application-prefer-dark-theme=true
  '';
in
{
  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
  ];

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = gtkSettings;
    "xdg/gtk-4.0/settings.ini".text = gtkSettings;
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Adwaita";
          font-name = "DejaVu Sans 11";
          color-scheme = "prefer-dark";
        };
      }
    ];
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "breeze";
  };
}
