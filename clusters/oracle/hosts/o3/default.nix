{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./networking
    ./hardware.nix
  ];

  features.disko = {
    enable = true;
    main = {
      device = "/dev/sda"; # First virtual drive
      imageSize = "49G";
    };
  };
}
