{inputs, ...}: {
  flake.nixosConfigurations.x570.configuration = {lib, ...}: {
    imports =
      [
        inputs.quadlet-nix.nixosModules.quadlet
      ]
      ++ (with inputs.self.nixosModules; [
        linuxPreset
        desktopPreset
        intelGraphics
        unbound
        wifi
        containerlab
        gaming
      ]);

    nix.settings.substituters = lib.mkBefore ["http://p520:5000"];
    system.stateVersion = "25.05";
    services.k3s.enable = true;

    # Containers
    environment.persistence."/cache".directories = [
      "/var/lib/containers"
      "/var/lib/open-webui"
      "/var/tmp"
    ];

    virtualisation.podman.enable = true;
  };
}
