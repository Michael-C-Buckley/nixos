{
  flake.modules.nixos.x570 = let
    wpDir = "/home/michael/Pictures/wallpapers";
  in {
    hjem.users.michael.files = {
      ".config/hypr/host.conf".text = ''
        #X570 Host-Specific
        # Main Ultrawide Monitor
        # monitor=DP-1,3440x1440@144.00,0x0,1 # B570
        monitor=DP-3,3440x1440@165.00,0x0,1 # 6700XT

        # Side 24" Monitor
        #monitor=HDMI-A-3,2560x1440@74.60,3440x-500,1,transform,3 # B570
        monitor=HDMI-A-1,2560x1440@74.60,3440x-500,1,transform,3 # 6700XT

        # Assign some sane workspace default to known monitors
        workspace=1, monitor:DP-1, default:true
        workspace=2, monitor:DP-1, default:true
        workspace=9, monitor:HDMI-A-3, default:true
        workspace=10, monitor:HDMI-A-3, default:true
      '';
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ${wpDir}/nord-2-imgur.png
        preload = ${wpDir}/nord-6-imgur.png
        wallpaper = DP-1, ${wpDir}/nord-6-imgur.png
        wallpaper = HDMI-A-3, ${wpDir}/nord-2-imgur.png
      '';
    };
  };
}
