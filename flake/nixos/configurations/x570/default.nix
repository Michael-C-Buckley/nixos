{config, ...}: {
  imports = [
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  features = {
    boot = "systemd";
    gaming.enable = true;
  };

  nix.settings = {
    substituters = ["http://p520:5000"];
  };

  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets.cachePrivateKey.path];
  };

  system = {
    preset = "desktop";
    stateVersion = "25.05";
  };
}
