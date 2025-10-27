{
  flake.modules.nixos.wsl = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # System
      hydra-cli
      socat
      clinfo

      # Development
      go
      gopls

      # Web
      qutebrowser
      legcord
    ];
  };
}
