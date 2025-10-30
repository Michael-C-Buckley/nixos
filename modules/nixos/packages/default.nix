{config, ...}: {
  flake.modules.nixos.packages = {pkgs, ...}: {
    nixpkgs.overlays = [config.flake.overlays.default];
    environment.systemPackages = with pkgs; [
      # Overlaid local packages
      nvf-minimal

      # System
      fastfetch
      microfetch
      killall
      npins

      # Security
      sops
      rage

      # File/Navigation
      bat
      dust
      duf
      eza
      fd
      fzf
      ripgrep
      yazi
      zip
      zoxide

      # Performance
      atop
      btop
      htop

      # Hardware
      usbutils
      pciutils

      # Machine Utilities
      gptfdisk
      parted
      usbutils
      pciutils
    ];
  };
}
