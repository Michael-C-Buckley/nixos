{
  flake.modules.nixos.gaming = {
    custom.impermanence.cache.user.directories = [".local/share/Steam"];

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
