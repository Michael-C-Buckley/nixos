_: let
  wpDir = "/home/michael/Pictures/wallpapers";
in {
  hjem.users.michael.files = {
    ".config/hypr/host.conf".text = ''
      monitor=eDP-1,1920x1080@60.01Hz,0x0,1
    '';

    ".config/hypr/hyprpaper.conf".text = ''
      preload = ${wpDir}/sundown-over-water.jpg
      wallpaper = , ${wpDir}/sundown-over-water.jpg
    '';
  };
}
