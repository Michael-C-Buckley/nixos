{
  flake,
  pkgs,
  lib,
  ...
}: {
  imports = with flake.modules.nixos;
    [
      impermanence
      systemd-boot
      laptopPreset
      wifi
      cosmicDesktop
    ]
    ++ [
      ./hardware
    ];

  networking = {
    hostId = "fd78a12b";
    hostName = "tempest";
  };

  programs = {
    hyprland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nixos-anywhere
    attic-client

    # Storage tools
    parted
    gptfdisk
    nvme-cli

    # Security
    sops
    ssh-to-age
  ];

  # Remove autologin
  services.greetd.settings.initial_session = lib.mkForce {};

  system.stateVersion = "25.05";
}
