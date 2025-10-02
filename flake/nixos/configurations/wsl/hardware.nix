{pkgs, ...}: {
  # For Intel Graphics
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
}
