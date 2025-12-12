{
  flake.modules.nixos.niri = {pkgs, ...}: {
    programs.niri.enable = true;
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      wireplumber
      playerctl
      kitty
      hyprlock
    ];
  };
}
