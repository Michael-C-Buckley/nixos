{config, ...}: {
  flake.modules.nixos.x570 = {
    imports = with config.flake.modules.nixos; [
      lanzaboote
      impermanence
      desktopPreset
      homelabPreset
      intelGraphics
      wifi
      gaming
      lab-network
      systemd-credentials
      secrets-nic-rename
    ];

    system.stateVersion = "25.05";

    # Containers (existing data but current disabled)
    environment.persistence."/cache".directories = [
      "/var/lib/containers"
      "/var/tmp"
    ];
  };
}
