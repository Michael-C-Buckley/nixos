{
  config,
  lib,
  ...
}: {
  options.programs.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic Desktop on host";
  };

  config = {
    services.desktopManager = {
      cosmic.enable = config.programs.cosmic.enable;
    };
  };
}
