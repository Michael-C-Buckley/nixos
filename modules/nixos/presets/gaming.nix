{
  flake.modules.nixos.gaming = {
    custom.impermanence.cache.allUsers.directories = [".local/share/Steam"];

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
