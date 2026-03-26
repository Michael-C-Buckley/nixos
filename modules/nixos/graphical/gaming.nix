{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    custom.impermanence.cache.allUsers.directories = [".local/share/Steam"];

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;
      # Disabling hardware acceleration allows it to work more consistently such as on Niri
      package = pkgs.steam.override {
        extraArgs = "-cef-disable-gpu -cef-disable-gpu-compositing";
      };
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
