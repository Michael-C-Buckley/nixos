{pkgs, ...}: {
  packageSets.extendedGraphical = with pkgs; [
    # System Utilities
    networkmanagerapplet
    pavucontrol # Pulse Volume control
    gammastep
    wireshark
    gparted

    # Browser
    firefox

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
    obsidian
    gimp3

    # Terminals
    ghostty

    # Communication
    bitwarden
  ];
}
