{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.system) impermanence;
  inherit (config.features) gaming;
in {
  options.features.gaming = {
    enable = mkEnableOption "Enable gaming on the host.";
  };

  config = mkIf gaming.enable {
    # Any Custom Filesystem mounts will be under the host itself
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    environment.persistence."/cache".users = mkIf impermanence.enable {
      # WIP: Add logic for all users
      michael.directories = [".steam"];
    };
  };
}
