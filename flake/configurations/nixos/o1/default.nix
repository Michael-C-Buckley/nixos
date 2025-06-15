{inputs, ...}: {
  imports = with inputs; [
    nix-secrets.nixosModules.oracle
    ./hardware.nix
    ./networking
  ];

  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  system = {
    boot.uuid = "";
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
