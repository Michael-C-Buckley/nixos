{pkgs, ...}:
with pkgs; [
  # Clipboard
  wl-clipboard
  xclip
  cliphist
  wl-clipboard-x11

  # Cursor
  graphite-cursors

  # Display
  cage

  # Terminals
  ghostty
  kitty

  # Desktop
  xfce.thunar # File manager

  # Communication
  vivaldi
]
