{
  host.impermanence.cache.directories = [
    "/var/lib/docker"
  ];

  flake.modules.nixosModules.containerlab = {pkgs, ...}: {
    # For now, use docker
    virtualisation.docker.enable = true;
    environment.systemPackages = [pkgs.containerlab];
  };
}
