{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.system) impermanence;
  inherit (config.features) gaming;

  commonDir = {directories = [".local/share/Steam"];};
in {
  options.features.gaming = {
    enable = mkEnableOption "Enable gaming on the host.";
  };

  config = mkIf gaming.enable {
    # Large, downloadable so remove from snapshots
    environment.persistence."/cache".users = mkIf impermanence.enable {
      michael = commonDir;
      shawn = commonDir;
    };
    # Any Custom Filesystem mounts will be under the host itself
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
