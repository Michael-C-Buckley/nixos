{pkgs, ...}: {
  packageSets.extendedGraphical = with pkgs; [
    # System Utilities
    pavucontrol # Pulse Volume control
    gammastep
    gparted
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

    # Terminals
    ghostty

    # Communication
    bitwarden
  ];
}
