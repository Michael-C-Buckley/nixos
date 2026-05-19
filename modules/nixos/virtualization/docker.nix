{pkgs, ...}: {
  environment.systemPackages = [pkgs.lazydocker];
  virtualisation.docker.enable = true;
  users.powerUsers.groups = ["docker"];
}
