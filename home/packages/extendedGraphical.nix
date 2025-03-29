{pkgs, ...}: with pkgs; [
  # System Utilities
  networkmanagerapplet
  cpu-x
  pavucontrol # Pulse Volume control
  gammastep
  wireshark

  # Desktop
  xfce.thunar # File manager

  # Media
  vlc
  zathura # PDF Viewer
  sxiv # Simple photo viewer

  # Productivity
  kdePackages.kalgebra # Calculator
  neovide # Nvim GUI
  obsidian
  libreoffice
  gimp
  zed-editor
]