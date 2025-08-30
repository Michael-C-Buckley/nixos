{inputs, ...}: let
  inherit (inputs) nix-secrets home-config;
in {
  imports = [
    nix-secrets.nixosModules.oracle
    home-config.hjemConfigurations.minimal
    ./hardware
    ./networking
  ];

  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  system = {
    boot.uuid = "12CE-A600";
    stateVersion = "25.11";
    preset = "cloud";
    zfs.enable = true;
    impermanence.enable = true;
  };

  features = {
    graphics = false;
    pkgs.fonts = false;
  };
}
