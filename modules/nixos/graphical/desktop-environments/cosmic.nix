{
  flake.modules.nixosModules.cosmicDesktop = {pkgs, ...}: {
    services.desktopManager.cosmic = {
      enable = true;
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
