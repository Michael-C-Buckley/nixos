# Base Entry for Home-Manager
{lib, ...}: {
  programs.home-manager.enable = true;

  home = {
    username = "michael";
    homeDirectory = "/home/michael";
    stateVersion = lib.mkDefault "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "schizofox";
      NIXOS_OZONE_WL = "1";
      GTK_USE_PORTAL = "1";
    };
  };
}
