{
  flake.modules.nixos.packages-desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # System Utilities
      networkmanagerapplet
      pavucontrol # Pulse Volume control
      gammastep
      gparted

      # Going simple with Nemo for now; more to follow
      nemo-with-extensions

      # Productivity
      qalculate-qt
      meld

      # Terminal
      ghostty

      # Media
      mpv
      imv
      zathura # PDF Viewer
      photoqt # Photo Viewer
      foliate # Ebook Reader

      # Office
      abiword
      gnumeric

      # Utility
      wireshark
      winbox4
    ];
  };
}
