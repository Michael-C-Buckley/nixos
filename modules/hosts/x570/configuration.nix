{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.x570 = {lib, ...}: {
    imports =
      [
        inputs.quadlet-nix.nixosModules.quadlet
      ]
      ++ (with config.flake.modules.nixos; [
        desktopPreset
        intelGraphics
        network
        unbound
        wifi
        containerlab
        gaming
        k3s
      ]);

    nix.settings.substituters = lib.mkBefore ["http://p520:5000"];
    system.stateVersion = "25.05";

    # Containers (existing data but current disabled)
    environment.persistence."/cache".directories = [
      "/var/lib/containers"
      "/var/lib/open-webui"
      "/var/tmp"
    ];

    virtualisation.podman.enable = true;
  };
}
