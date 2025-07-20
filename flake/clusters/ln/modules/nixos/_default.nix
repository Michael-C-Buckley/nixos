_: {
  system = {
    stateVersion = "25.11";
    impermanence.enable = true;
    preset = "server";
  };

  virtualisation = {
    libvirtd.enable = true;
  };
}
