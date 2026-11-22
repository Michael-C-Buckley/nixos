{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.wavemon
  ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
