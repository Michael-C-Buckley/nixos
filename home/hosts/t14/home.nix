{...}: {
  imports = [
    ../../modules/graphics.nix
  ];
  home = {
    stateVersion = "24.05";
    # Link Hyprland host specific file
    file.".config/hypr/host.conf".source = ./hyprland.conf;
  };

  features.michael.useHome = false;
}
