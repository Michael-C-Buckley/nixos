{
  flake.modules.nixos.docker = {pkgs, ...}: {
    environment.systemPackages = [pkgs.lazydocker];
    virtualisation.docker.enable = true;
    users.powerUsers.groups = ["docker"];
  };
}
