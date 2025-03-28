{config,...}:
let
  gfx = config.features.graphics;
in {
  programs = {
    hyprland.enable = gfx;
    hyprlock.enable = gfx;
  };
}
