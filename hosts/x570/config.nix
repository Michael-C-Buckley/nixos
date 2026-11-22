{
  imports = [
    ./hardware.nix
    ./network.nix
    ./filesystems.nix
  ];

  hjem.users.michael = {
    custom.umbriel.settings.output.DP-1 = {
      mode = "3440x1440@165.000";
      workspaces = 10;
    };

    programs.hyprland.extraLuaFiles.personal.content = ./hyprland.lua;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.greetd.settings.initial_session = {
    user = "michael";
    command = "start-hyprland";
  };

  users.users.michael.uid = 1000;
}
