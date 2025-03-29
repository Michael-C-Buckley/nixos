# ADD options and enable this module
_: {
  # Set common Nvidia options
  # User will still need to set their own package version
  boot.blacklistedKernelModules = ["nouveau"];
  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    graphics.enable = true;
    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
    };
  };
}
