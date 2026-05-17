{config, ...}: {
  flake.modules.nixos.hyprland = {pkgs, ...}: {
    programs = {
      hyprland.enable = true;
    };

    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";

        # fix java bug on tiling wm's / compositors
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      systemPackages = with pkgs;
        [
          hyprshot
          hyprcursor
          hyprpolkitagent # Auth agent
          xdg-desktop-portal

          # Clipboard
          clipse
          wl-clip-persist
          wl-clipboard
          xclip
        ]
        ++ [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.noctalia];
    };
  };
}
