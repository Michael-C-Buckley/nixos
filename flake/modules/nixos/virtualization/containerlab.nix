{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.virtualisation.containerlab = {
    enable = mkEnableOption "Enable Nokia's ContainerLab.";
  };

  config = mkIf config.virtualisation.containerlab.enable {
    # For now, use docker
    virtualisation.docker.enable = true;
    environment.systemPackages = [pkgs.containerlab];
  };
}
