{
  flake.modules.nixosModules.system = {
    pkgs,
    lib,
    ...
  }: {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_16;
    time.timeZone = "America/New_York";
    environment.enableAllTerminfo = true;
  };
}
