{self, ...}: {
  imports = [
     "${self}/configurations/modules/presets/michael.nix"
  ];

  system = {
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
