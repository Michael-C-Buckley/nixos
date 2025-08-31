{pkgs, ...}: {
  packageSets.extendedGraphical = with pkgs; [
    # System Utilities
    networkmanagerapplet
    pavucontrol # Pulse Volume control
    gammastep
    gparted
    wireshark

    # Browser
    vivaldi

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
    gimp3

    # Terminals
    ghostty

    # Communication
    bitwarden
  ];
}
