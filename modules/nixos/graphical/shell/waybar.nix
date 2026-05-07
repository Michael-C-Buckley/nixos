{
  flake.modules.nixos.waybar = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard

      bemenu
      fuzzel
      swaylock
      gammastep

      waybar
      wleave
      mako
      swaynotificationcenter
      networkmanagerapplet
      mpd-mpris
      waybar-mpris
    ];
  };
}
