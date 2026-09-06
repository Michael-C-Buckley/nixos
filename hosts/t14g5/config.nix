{
  imports = [
    ./hardware.nix
    ./filesystems.nix
    ./network.nix
    ./night-led.nix
  ];

  custom.umbriel.extraConfig.output.eDP-1 = {
    mode = "1920x1200@60.001";
    workspaces = 10;
  };
}
