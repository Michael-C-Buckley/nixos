let
  # Center Monitor, 34" ultrawide
  mon1 = "DP-1";
  # Right side monitor, vertical 24"
  mon2 = "HDMI-A-3";
in {
  flake.modules.nixos.x570 = {
    hjem.users.michael.files = {
      ".config/hypr/host.conf".text = ''
        #X570 Host-Specific
        monitor=${mon1},3440x1440@144.00,0x0,1
        monitor=${mon2},2560x1440@74.60,3440x-500,1,transform,3

        # Assign some sane workspace default to known monitors
        workspace=1, monitor:${mon1}, default:true
        workspace=2, monitor:${mon1}, default:true
        workspace=9, monitor:${mon2}, default:true
        workspace=10, monitor:${mon2}, default:true
      '';
    };
  };
}
