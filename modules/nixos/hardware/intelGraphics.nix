{
  flake.modules.nixos.intelGraphics = {pkgs, ...}: {
    boot.kernelModules = ["i915"];
    environment.systemPackages = [pkgs.clinfo];

    hardware = {
      intel-gpu-tools.enable = true;
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
  };
}
