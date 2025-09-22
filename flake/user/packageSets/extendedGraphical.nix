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
  sakura
  kitty
  alacritty
  wezterm

  # Communication
  bitwarden-desktop
  bitwarden-cli
  materialgram
]
