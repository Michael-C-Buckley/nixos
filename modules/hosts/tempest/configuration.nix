{config, ...}: {
  flake.modules.nixos.tempest = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.modules.nixos; [
      laptopPreset
      wifi
      cosmicDesktop
    ];

    networking = {
      hostId = "fd78a12b";
      hostName = "tempest";
    };

    programs = {
      hyprland.enable = true;
    };

    # Gnome for the environment
    services.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
      nixos-anywhere

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

    system = {
      stateVersion = "25.05";
      zfs.encryption = true;
    };
  };
}
