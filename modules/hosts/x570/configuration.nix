{config, ...}: {
  flake.modules.nixos.x570 = {
    imports = with config.flake.modules.nixos; [
      desktopPreset
      homelabPreset
      intelGraphics
      wifi
      gaming
      lab-network
    ];

    system.stateVersion = "25.05";

    # Containers (existing data but current disabled)
    environment.persistence."/cache".directories = [
      "/var/lib/containers"
      "/var/tmp"
    ];
  };
}
