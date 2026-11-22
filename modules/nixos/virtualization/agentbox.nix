{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Move this once I figure out how I want to position it
  environment.systemPackages = [ (pkgs.callPackage ../../../packages/agentbox { }) ];

  # Include a container engine if none is enabled.
  virtualisation.docker.enable = lib.mkIf (!config.virtualisation.podman.enable) (lib.mkDefault true);
}
