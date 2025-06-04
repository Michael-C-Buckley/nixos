{lib, ...}: {
  system = {
    preset = "server";
    stateVersion = lib.mkDefault "25.11";
    impermanence.enable = true;
    zfs.enable = true;
  };

  services = {
    k3s.enable = true;
  };

  virtualisation = {
    incus.enable = true;
  };
}
