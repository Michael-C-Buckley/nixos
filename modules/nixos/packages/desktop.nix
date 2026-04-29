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

      # Security
      keepassxc
      keepassxc-go
      keepass-diff
      passage

      # Terminal
      kitty
      yazi

      # Utility
      attic-client
      wireshark
      putty
      winbox4

      # Communication
      signal-desktop
      legcord
      materialgram

      # Productivity
      novelwriter
    ];
  };
}
