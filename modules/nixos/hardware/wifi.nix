{
  flake.nixosModules.wifi = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      blueman
      wavemon
    ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
