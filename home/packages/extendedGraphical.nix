{pkgs, ...}:
with pkgs; [
  # System Utilities
  networkmanagerapplet
  cpu-x
  pavucontrol                   # Pulse Volume control
  gammastep
  wireshark

  # Extra things I'm just checking out
  flow-control

  # Cursors
  nordzy-cursor-theme           # Only active theme

  # Desktop
  xfce.thunar                   # File manager

  # Media
  vlc
  sxiv                          # Simple photo viewer

  # Productivity
  kdePackages.kalgebra          # Calculator
  obsidian
  gimp3

  # Development
  nix-search-tv

  # Communication
  vivaldi
  bitwarden
  signal-desktop-bin
  discord
  materialgram                  # Telegram fork
]
