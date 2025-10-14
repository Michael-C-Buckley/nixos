{
  flake.modules.nixos.wsl = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # System
      fastfetch
      microfetch
      killall
      hydra-cli
      socat
      clinfo

      # Development
      go
      gopls

      # Web
      qutebrowser
      legcord

      # Shells
      nushell
      tmux
      starship

      # File/Navigation
      fd
      dust
      fzf
      ripgrep
      wget

      # Performance
      btop

      # Hardware
      usbutils
      pciutils

      # Network
      dig
      dhcpcd
      nmap
      iperf
      tcpdump
      inetutils
      ndisc6
      frr
      nettools
    ];
  };
}
