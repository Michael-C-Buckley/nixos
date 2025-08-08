{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic Desktop on host";
  };

  config = {
    services.desktopManager = {
      cosmic.enable = config.programs.cosmic.enable;
    };
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-greeter
      cosmic-store
      cosmic-design-demo
    ];
  };
}
