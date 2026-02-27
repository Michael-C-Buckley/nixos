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

      # Terminal
      kitty
      yazi

      # Utility
      attic-client
      yubioath-flutter
      wireshark
      putty
      winbox4
    ];
  };
}
