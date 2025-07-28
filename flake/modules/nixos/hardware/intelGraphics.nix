# Intel config
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hardware.graphics) useIntel;
  inherit (lib) mkEnableOption mkIf;
in {
  options.hardware.graphics = {
    useIntel = mkEnableOption "Enable and configure standard Intel Graphics options.";
  };

  config = mkIf useIntel {
    boot.kernelModules = ["i915"];

    hardware = {
      enableRedistributableFirmware = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-compute-runtime
          intel-graphics-compiler
          intel-vaapi-driver
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
