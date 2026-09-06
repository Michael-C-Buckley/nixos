{
  imports = [
    ./hardware.nix
    ./network.nix
    ./filesystems.nix
  ];

  custom.umbriel.extraConfig.output.eDP-1 = {
    mode = "3440x1440@165.000";
    workspaces = 10;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
