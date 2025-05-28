{self, ...}: {
  imports = [
    "${self}/configurations/modules/presets/michael.nix"
    ./modules
    ./network
  ];

  # Logrotate randomly breaking?
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  # services.logrotate.checkConfig = false;

  system = {
    stateVersion = "25.11";
    preset = "server";
    impermanence.enable = true;
  };

  services = {
    k3s.enable = false; # while still deploying
  };

  virtualisation = {
    incus.enable = false;
  };
}
