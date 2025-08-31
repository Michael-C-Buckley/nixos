# Persistent USB NVMe install
{pkgs, ...}: {
  imports = [
    ./hardware
  ];

  networking = {
    hostId = "fd78a12b";
    hostName = "tempest";
  };

  programs = {
    cosmic.enable = true;
    hyprland.enable = true;
  };

  # Gnome for the environment
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = import ./packages.nix {inherit pkgs;};

  features = {
    michael.extendedGraphical = true;
    autoLogin = false;
    displayManager = "greetd";
    gaming.enable = false;
    pkgs.fonts = true;
  };

  system = {
    preset = "laptop";
    stateVersion = "25.05";
    impermanence.enable = true;
    zfs = {
      enable = true;
      encryption = true;
    };
  };
}
