# Dank Material Shell
{
  flake.modules.nixos.dms = {
    programs.dms-shell = {
      enable = true;
    };
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "hyprland"; # I'll PR and fix this on nixpkgs, it doesn't have everything
      configHome = "/home/michael";
    };
  };
}
