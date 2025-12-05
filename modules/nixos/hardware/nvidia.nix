{
  flake.modules.nixos.nvidia = {
    boot.blacklistedKernelModules = ["nouveau"];
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
  };
}
