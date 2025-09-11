{pkgs, ...}:
with pkgs; [
  # System Utilities
  wireshark

  # Editors
  emacs
  meld
  vscodium-fhs

  # Terminals
  ghostty
  kitty
  kitty-themes

  # Communication
  bitwarden-desktop
  bitwarden-cli
  materialgram
]
