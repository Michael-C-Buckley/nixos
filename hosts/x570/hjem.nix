_: {
  hjem.users.michael.files.".config/hypr/host.conf".text = ''
    # Main Ultrawide Monitor
    monitor=DP-1,3440x1440@144.00,0x0,1

    # Side 24" Monitor
    monitor=HDMI-A-2,2560x1440@59.95,3440x-500,1,transform,3

    # Assign some sane workspace default to known monitors
    workspace=1, monitor:DP-1, default:true
    workspace=2, monitor:DP-1, default:true
    workspace=9, monitor:HDMI-A-2, default:true
    workspace=10, monitor:HDMI-A-2, default:true

    # Overwrite the default so Xwayland is used
    # Zen is causing a weird series of stability issues only here
    bind=$mod, O, exec, MOZ_ENABLE_WAYLAND=0 $browser
  '';

  features.michael = {
    extendedGraphical = true;
    vscode.enable = true;
    waybar.enable = true;
    hyprland.enable = true;
    packages.zed.include = true;
  };
}
