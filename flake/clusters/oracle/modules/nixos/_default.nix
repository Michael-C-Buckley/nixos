{inputs, ...}: {
  imports = with inputs; [
    disko.nixosModules.disko
    nix-secrets.nixosModules.oracle
  ];

  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  system = {
    preset = "cloud";
    zfs.enable = true;
  };

  features = {
    graphics = false;
    pkgs.fonts = false;
  };
}
