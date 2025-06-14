{inputs, ...}: {
  imports = with inputs; [
    disko.nixosModules.disko
    nix-secrets.nixosModules.oracle
    # ./disko.nix
    ./hardware.nix
    ./networking
  ];

  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  system = {
    stateVersion = "25.11";
    preset = "cloud";
    zfs.enable = true;

    disko = {
      enable = true;
      main = {
        device = "/dev/sda";
        swapSize = "4G";
        imageSize = "200G";
      };
    };

    impermanence = {
      enable = true;
      usePreset = false;
    };
  };

  features = {
    graphics = false;
    pkgs.fonts = false;
  };
}
