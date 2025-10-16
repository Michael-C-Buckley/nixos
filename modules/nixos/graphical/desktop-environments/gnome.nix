{
  flake.modules.nixos.gnomeDesktop = {pkgs, ...}: {
    services.desktopManager.gnome = {
      enable = true;
      wayland = true;
    };

    # Removing bloatware from Gnome
    environment.gnome.excludePackages = with pkgs; [
      baobab # disk usage analyzer
      cheese # photo booth
      eog # image viewer
      epiphany # web browser
      simple-scan # document scanner
      totem # video player
      yelp # help viewer
      evince # document viewer
      file-roller # archive manager
      geary # email client
      seahorse # password manager

      # these should be obvious
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-screenshot
      gnome-system-monitor
      gnome-weather
      gnome-disk-utility
      gnome-connections
    ];
  };
}
