{
  flake.modules.nixos.packages-desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # System Utilities
      networkmanagerapplet
      pavucontrol # Pulse Volume control

      # Going simple with Nemo for now; more to follow
      nemo-with-extensions

      # Productivity
      gnome-calculator
      meld

      # Terminal
      ghostty

      # Media
      mpv
      imv
      photoqt # Photo Viewer

      # Office
      abiword
      gnumeric

      # Utility
      attic-client
      wireshark
      winbox4
    ];
  };
}
