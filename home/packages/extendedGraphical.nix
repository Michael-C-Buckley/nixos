{pkgs, ...}:
with pkgs; [
  # System Utilities
  networkmanagerapplet
  cpu-x
  pavucontrol                   # Pulse Volume control
  gammastep
  wireshark

  # Extra things I'm just checking out
  flow-control

  # Cursors
  nordzy-cursor-theme           # Only active theme

  # Desktop
  kdePackages.dolphin

  # Media
  vlc
  kdePackages.koko              # Photo viewer

  # Productivity
  kdePackages.kalgebra          # Calculator
  obsidian
  gimp3

  # Development
  # **Persist: ~/.cache/nix-search-tv
    (writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })

  # Communication
  vivaldi
  bitwarden
  signal-desktop-bin
  legcord
  materialgram                  # Telegram fork
]
