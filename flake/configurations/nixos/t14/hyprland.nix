_: let
  wpDir = "/home/michael/Pictures/wallpapers";
in {
  hjem.users.michael = {
    programs.hyprland.extraConfig = ''
      # T14 Host-specific
      monitor=eDP-1,1920x1080@60.01Hz,0x0,1
    '';

    files = {
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ${wpDir}/sundown-over-water.jpg
        wallpaper = , ${wpDir}/sundown-over-water.jpg
      '';
    };
  };
}
