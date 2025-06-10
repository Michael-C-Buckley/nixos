_: {
  system = {
    stateVersion = "25.11";
    impermanence.enable = true;
    resolved.enable = false;
    preset = "server";
  };

  virtualisation = {
    incus.enable = true;
  };
}
