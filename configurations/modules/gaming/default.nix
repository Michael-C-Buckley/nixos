{
  config,
  lib,
  ...
}: {
  options.features.gaming = {
    enable = lib.mkEnableOption "Enable gaming on the host.";
  };

  config = lib.mkIf config.features.gaming.enable {
    # Any Custom Filesystem mounts will be under the host itself
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
