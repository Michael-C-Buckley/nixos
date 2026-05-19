# WIP setup for myself that doesn't use something like Noctalia or DMS
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard

    wmenu
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
}
