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
  flow-control    # Simple TUI IDE

  # Communication
  vivaldi
  librewolf
]
