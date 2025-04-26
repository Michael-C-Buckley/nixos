_: {
  hjem.users.michael.files.".config/hypr/host.conf".text = ''
    monitor=eDP-1,1920x1080@60.01Hz,0x0,1
  '';

  features.michael = {
    extendedGraphical = true;
    vscode.enable = true;
    waybar.enable = true;
    hyprland.enable = true;
    zed.include = true;
    nvf.package = "default";
  };
}
