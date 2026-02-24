{
  flake.modules.nixos.packages-desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # System Utilities
      cage
      networkmanagerapplet
      pavucontrol # Pulse Volume control
      kubectl
      npins
      nvfetcher

      # Communication
      legcord
      signal-desktop
      materialgram

      # Productivity
      gnome-calculator
      meld

      # Media
      mpv
      imv
      photoqt # Photo Viewer

      # Terminal
      kitty
      yazi

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
