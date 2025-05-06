# X570 Desktop Configuration
{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    inputs.nix-index-database.nixosModules.nix-index
    ./hardware
    ./networking
  ];

  system = {
    preset = "desktop";
    stateVersion = "24.05";
    zfs.enable = true;
  };

  programs = {
    hyprland.enable = true;
    cosmic.enable = false;
    nix-index-database.comma.enable = true;
  };

  features = {
    michael = {
      nvf.package = "default";
      extendedGraphical = true;
      vscode.enable = true;
      waybar.enable = true;
      hyprland.enable = true;
    };
    displayManager = "greetd";
    gaming.enable = true;
    pkgs.fonts = true;
  };

  services.nix-serve.enable = true;

  virtualisation = {
    incus.enable = true;
    libvirtd.enable = true;
    gns3.enable = true;
  };

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
  '';
}
