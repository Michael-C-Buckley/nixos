{ pkgs, ... }: {
  packages = with pkgs; [
    codex
    claude-code
    signal-desktop
    imv
    mpv
    xarchiver
    zathura
  ];
}
