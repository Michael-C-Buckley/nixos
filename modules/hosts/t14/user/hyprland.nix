{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.nixos.t14 = {pkgs, ...}: {
    hjem.users.michael.xdg.config.files."hypr/hyprland.conf".source = flakeConfig.flake.custom.wrappers.mkHyprlandConfig {
      inherit pkgs;
      hostConfig = pkgs.writeText "t14-hyprland-conf" ''
        # T14 Host-specific
        monitor=eDP-1,1920x1080@60.01Hz,0x0,1

        # Portable Monitor, sometimes used
        monitor=DP-1,1920x1080@60.00Hz,-1920x0,1
      '';
    };
  };
}
