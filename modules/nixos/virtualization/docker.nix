{
  flake.modules.nixos.docker = {pkgs, ...}: {
    custom.impermanence.cache.directories = [
      "/var/lib/docker"
    ];
    environment.systemPackages = [pkgs.lazydocker];
    virtualisation.docker.enable = true;
    users.powerUsers.groups = ["docker"];
  };
}
