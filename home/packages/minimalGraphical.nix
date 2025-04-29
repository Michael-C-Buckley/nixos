{pkgs, ...}:
with pkgs; [
  # Clipboard
  wl-clipboard
  xclip
  cliphist
  wl-clipboard-x11

  # Display
  cage

  # Terminals
  ghostty
  kitty

  # Desktop
  xfce.thunar # File manager

  # Communication
  vivaldi
  librewolf
]
