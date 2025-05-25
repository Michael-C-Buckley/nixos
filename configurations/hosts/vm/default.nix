_: {
  imports = [
    ./hardware.nix
  ];

  networking = {
    hostName = "vm";
    hostId = "11111111";
  };

  system = {
    preset = "desktop";
    disko = {
      enable = true;
      main = {
        device = "/dev/sda"; # First virtual drive
        imageSize = "10G";
      };
    };
  };
}
