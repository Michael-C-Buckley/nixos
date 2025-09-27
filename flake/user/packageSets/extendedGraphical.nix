{pkgs, ...}:
with pkgs; [
  # System Utilities
  wireshark

  # Editors
  emacs
  meld
  flow-control

  # Terminals
  ghostty
  kitty
  kitty-themes
  sakura
  kitty
  alacritty
  wezterm

  # Communication
  bitwarden-desktop
  bitwarden-cli
  materialgram
]
