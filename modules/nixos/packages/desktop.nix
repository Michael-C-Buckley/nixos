{config, ...}: {
  flake.modules.nixos.packages-desktop = {pkgs, ...}: let
    fpkgs = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
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
        ghostty
        kitty
        nushell
        yazi
        starship
        # Utility
        wmenu
        gammastep
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
        helix
        ;
      inherit
        (fpkgs)
        zeditor
        helium
        ns
        ;
    };

    fonts.packages = with pkgs; [
      dejavu_fonts
      cascadia-code
      jetbrains-mono
    ];
  };
}
