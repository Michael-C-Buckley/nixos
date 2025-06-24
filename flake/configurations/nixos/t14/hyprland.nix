_: let
  wpDir = "/home/michael/Pictures/wallpapers";
  paper1 = "${wpDir}/deviant/sky_light_by_bisbiswas_de3r7zn.jpg";
in {
  hjem.users.michael = {
    programs.hyprland.extraConfig = ''
      # T14 Host-specific
      monitor=eDP-1,1920x1080@60.01Hz,0x0,1

      # Portable Monitor, sometimes used
      monitor=DP-1,1920x1080@60.00Hz,-1920x0,1
    '';

    files = {
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ${paper1}
        wallpaper = , ${paper1}
      '';
    };
  };
}
