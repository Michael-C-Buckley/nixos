{ pkgs, ... }: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
  };
  security.polkit.enablePkexecWrapper = true;
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
    systemPackages = with pkgs; [
      hyprland-guiutils
      hyprcursor
      hyprpolkitagent
      xdg-desktop-portal
      clipse
      wl-clip-persist
      wl-clipboard
      xclip
    ];
  };
}
