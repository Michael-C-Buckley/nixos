# Packages specific to Linux graphical environments
{pkgs, ...}:
with pkgs; [
  # System Utilities
  networkmanagerapplet
  pavucontrol # Pulse Volume control
  gammastep
  gparted

  # Browser
  qutebrowser

  # Dolphin
  #kdePackages.dolphin
  #kdePackages.dolphin-plugins
  #kdePackages.ark
  #kdePackages.ffmpegthumbs
  #kdePackages.kdegraphics-thumbnailers
  #kdePackages.kompare
  #kdePackages.kdenetwork-filesharing

  # Going simple with Nemo for now; more to follow
  nemo-with-extensions

  # Productivity
  kdePackages.kalgebra # Calculator
  obsidian

  # Media
  mpv
  imv
  zathura # PDF Viewer
  kdePackages.koko # Photo Viewer
  foliate # Ebook Reader

  # Office
  abiword
  gnumeric

  # Communication
  signal-desktop
  legcord

  nil # For use with vscodium until I wrap it
]
