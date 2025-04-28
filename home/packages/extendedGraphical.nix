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
  # graphite-cursors
  # bibata-cursors
  nordzy-cursor-theme           # Only active theme

  # Desktop
  xfce.thunar                   # File manager

  # Media
  vlc
  zathura                       # PDF Viewer
  sxiv                          # Simple photo viewer

  # Productivity
  kdePackages.kalgebra          # Calculator
  neovide # Nvim GUI
  obsidian
  libreoffice
  gimp3
  zed-editor

  # Communication
  bitwarden
  signal-desktop-bin
  discord
  materialgram                  # Telegram fork
  tor-browser
]
