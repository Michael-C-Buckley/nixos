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
      cosmic-files
      cosmic-greeter
      cosmic-player
      cosmic-store
      cosmic-term
      # keep-sorted end
    ];
  };
}
