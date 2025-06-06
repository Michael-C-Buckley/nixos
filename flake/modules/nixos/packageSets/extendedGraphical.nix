{pkgs, ...}: {
  packageSets.extendedGraphical = with pkgs; [
    # System Utilities
    networkmanagerapplet
    cpu-x
    pavucontrol # Pulse Volume control
    gammastep
    wireshark

    # Editors
    emacs
    meld

    # File Explorer
    xfce.thunar

    # Media
    mpv
    imv
    zathura # PDF Viewer
    kdePackages.koko # Photo Viewer
    foliate # Ebook Reader

    # Productivity
    kdePackages.kalgebra # Calculator
    kdePackages.calligra
    obsidian
    gimp3

    # Terminals
    kitty
    wezterm

    # Communication
    bitwarden
  ];
}
