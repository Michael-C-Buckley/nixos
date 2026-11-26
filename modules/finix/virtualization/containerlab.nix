{ modules, pkgs, ... }:
{
  imports = [ modules.docker ];

  environment.systemPackages = [ pkgs.containerlab ];

  users.groups.clab_admins = { };
  users.users.michael.extraGroups = [
    "clab_admins"
    "docker"
  ];

  services.docker.enable = true;
}
