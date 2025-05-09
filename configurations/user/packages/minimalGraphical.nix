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
  flow-control    # Simple TUI IDE

  # Communication
  librewolf
]
