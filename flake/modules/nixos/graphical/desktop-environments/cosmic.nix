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
    services.desktopManager.cosmic = {
      inherit (config.programs.cosmic) enable;
      showExcludedPkgsWarning = false;
    };
    environment.cosmic.excludePackages = with pkgs; [
      # keep-sorted start
      cosmic-design-demo
      cosmic-edit
      cosmic-greeter
      cosmic-store
      cosmic-terminal
      # keep-sorted end
    ];
  };
}
