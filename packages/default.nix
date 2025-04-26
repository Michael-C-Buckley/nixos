{
  pkgs,
  inputs,
  system,
  ...
}: let
  wfetch = inputs.wfetch.packages.${system}.default;
  commonPkgs = with pkgs; [
    # System
    fastfetch
    microfetch
    killall
    nh

    # Shells (Zsh defined on its own)
    nushell
    tmux
    wfetch
    starship
    comma

    # Development/Management
    python3
    git
    tig

    # File/Navigation
    lsd
    eza
    fd
    du-dust
    fzf
    zoxide
    bat
    ripgrep
    wget
    zip

    # Performance
    atop
    btop
    htop

    # Hardware
    usbutils
    pciutils
    smartmontools
    lm_sensors
  ];
in {
  imports = [
    ./fonts.nix
    ./network.nix
    ./options.nix
    ./wifi.nix
  ];

  users.users = {
    michael.packages = commonPkgs;
    root.packages = commonPkgs;
  };
}
