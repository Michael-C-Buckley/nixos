{
  flake.modules.nixos.hyprland = {
    hjem.users.michael.files = {
      ".config/hypr/hyprland.conf".source = ./hyprland.conf;
      ".config/hypr/binds.conf".source = ./binds.conf;
      ".config/hypr/lookfeel.conf".source = ./lookfeel.conf;
    };
  };
}
