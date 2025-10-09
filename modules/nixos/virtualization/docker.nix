{
  host.impermanence.cache.directories = [
    "/var/lib/docker"
  ];

  flake.modules.nixosModules.docker = {pkgs, ...}: {
    environment.systemPackages = [pkgs.lazydocker];
    virtualisation.docker.enable = true;
    users.powerUsers.groups = ["docker"];
  };
}
