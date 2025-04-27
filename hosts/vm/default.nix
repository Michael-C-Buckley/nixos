_: {
  imports = [
    ./hardware.nix
  ];

  networking.hostId = "11111111";

  # programs.hyprland.enable = true;

  features = {
    # displayManager = "greetd";

    disko = {
      enable = true;
      main = {
        device = "/dev/sda"; # First virtual drive
        imageSize = "20G";
      };
    };
  };
}
