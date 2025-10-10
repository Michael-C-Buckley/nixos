# Persistent USB NVMe install
{pkgs, ...}: {
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

  environment.systemPackages = with pkgs; [
    brightnessctl
    nixos-anywhere

    # Storage tools
    parted
    gptfdisk
    nvme-cli

    # Security
    sops
    ssh-to-age
  ];

  features = {
    michael.extendedGraphical = true;
    autoLogin = false;
    displayManager = "greetd";
    gaming.enable = false;
  };

  system = {
    stateVersion = "25.05";
    impermanence.enable = true;
    zfs = {
      enable = true;
      encryption = true;
    };
  };
}
