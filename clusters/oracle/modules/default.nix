_: {
  imports = [
    ./networking.nix
  ];

  features = {
    graphics = false;
    pkgs.fonts = false;
  };
}
