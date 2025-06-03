{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  features = {
    graphics = false;
    pkgs.fonts = false;
  };
}
