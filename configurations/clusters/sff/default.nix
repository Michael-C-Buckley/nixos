{self, ...}: {
  imports = [
    "${self}/configurations/modules/presets/michael.nix"
    ./modules
    ./network
  ];

  system = {
    stateVersion = "25.11";
    preset = "server";
    impermanence.enable = true;
  };

  services = {
    k3s.enable = true;
  };

  virtualisation = {
    incus.enable = true;
  };
}
