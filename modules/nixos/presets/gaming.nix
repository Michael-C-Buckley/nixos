{
  host.impermanence.cache.user.directories = [".local/share/Steam"];

  flake.nixosModules.gaming = {
    # Large, downloadable so remove from snapshots
    # Any Custom Filesystem mounts will be under the host
    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
