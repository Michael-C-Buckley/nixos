{
  programs.dms-shell = {
    enable = true;
  };
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/michael";
  };
}
