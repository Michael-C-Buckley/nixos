_: {
  imports = [
    ../../modules/graphics.nix
  ];
  home = {
    stateVersion = "24.05";
  };

  # home.packages = (import ../../packages/graphical.nix {inherit pkgs;});
  features.michael.useHome = false;
}
