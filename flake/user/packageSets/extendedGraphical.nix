{
  self,
  pkgs,
  ...
}:
with pkgs;
  [
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
  ]
  ++ [
    self.packages.${pkgs.system}.helium
  ]
