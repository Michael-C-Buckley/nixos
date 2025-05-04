{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./networking.nix
    # ./disko.nix
  ];

  features = {
    graphics = false;
    pkgs.fonts = false;
  };
}
