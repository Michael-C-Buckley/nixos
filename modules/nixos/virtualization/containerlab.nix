let
  extraGroups = [
    "clab_admins"
    "docker"
  ];
in
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    containerlab
  ];

  users.users = {
    michael = { inherit extraGroups; };
    shawn = { inherit extraGroups; };
  };

  virtualisation.docker.enable = true;
}
