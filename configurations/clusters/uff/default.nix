_: {
  imports = [
    ../../modules/presets/michael.nix
    ./modules
    ./network
  ];

  services = {
    k3s.enable = true;
  };

  virtualisation = {
    incus.enable = true;
  };
}
