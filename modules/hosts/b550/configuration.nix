{config, ...}: {
  flake.modules.nixos.b550 = {
    imports = with config.flake.modules.nixos; [
      serverPreset
      network-no-static-default
      containerlab
      libvirt
      netbird
      attic
    ];

    nix.settings.substituters = ["http://p520:5000"];
    system.stateVersion = "26.05";

    # Containers (existing data but current disabled)
    environment.persistence."/cache".directories = [
      "/var/lib/containers"
      "/var/tmp"
    ];
  };
}
