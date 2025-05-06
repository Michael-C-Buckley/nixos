{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.oracle
    ./modules
  ];

  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  system = {
    preset = "cloud";
    zfs.enable = true;
  };
}
