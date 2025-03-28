{config, lib, ...}: {
  options.features.gaming = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable gaming on the host.";
  };

  config = lib.mkIf config.features.gaming {
    # Any Custom Filesystem mounts will be under the host itself
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
