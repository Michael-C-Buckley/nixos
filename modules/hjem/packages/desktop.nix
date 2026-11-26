{ pkgs, ... }: {
  packages = with pkgs; [
    codex
    claude-code
    signal-desktop
    localHelix
    imv
    mpv
    xarchiver
    zathura
  ];
}
