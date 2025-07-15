_: {
  system = {
    preset = "server";
    stateVersion = "25.11";
    impermanence.enable = true;
    zfs.enable = true;
  };

  services = {
    unbound.enable = true;
  };

  virtualisation = {
    incus.enable = true;
    podman.enable = true;
  };
}
