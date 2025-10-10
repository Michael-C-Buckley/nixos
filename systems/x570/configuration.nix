{lib, ...}: {
  nix.settings = {
    substituters = lib.mkBefore ["http://p520:5000"];
  };

  system = {
    stateVersion = "25.05";
  };

  services.k3s.enable = true;
}
