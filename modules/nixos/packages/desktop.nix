{
  flake.modules.nixos.packages-desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # System Utilities
      cage
      networkmanagerapplet
      pavucontrol # Pulse Volume control
      kubectl
      npins

      # Productivity
      gnome-calculator
      meld

      # Media
      mpv
      imv
      photoqt # Photo Viewer

      # Terminal
      kitty

      # Office
      abiword
      gnumeric

      # Utility
      attic-client
      yubioath-flutter
      wireshark
      winbox4
    ];
  };
}
