{inputs, ...}: {
  imports = with inputs; [
    disko.nixosModules.disko
    nix-secrets.nixosModules.oracle
    ./disko.nix
    ./hardware.nix
    ./networking
  ];

  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  system = {
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
