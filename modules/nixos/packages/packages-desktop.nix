{
  pkgs,
  flake,
  ...
}: let
  fpkgs = flake.packages.${pkgs.stdenv.hostPlatform.system};
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
    jetbrains-mono
    dejavu_fonts
    commit-mono
    vista-fonts
    font-awesome
    geist-font
    cascadia-code
    ibm-plex
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.symbols-only
    nerd-fonts.lilex
  ];
}
