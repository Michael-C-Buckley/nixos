# Intel config
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hardware.graphics = {
    useIntel = lib.mkEnableOption "Enable and configure standard Intel Graphics options.";
  };

  config = {
    boot.kernelModules = ["i915"];

    hardware = {
      enableRedistributableFirmware = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-compute-runtime
          intel-graphics-compiler
          intel-ocl
          ocl-icd
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      clinfo
    ];
  };
}
