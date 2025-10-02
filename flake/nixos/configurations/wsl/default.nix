{
  hardware = {
    intel-gpu-tools.enable = true;
    graphics.useIntel = true;
  };

  networking = {
    hostName = "wsl";
    hostId = "e07f0101";
    nameservers = [
      "::1"
      "127.0.0.1"
      "1.1.1.1"
      "9.9.9.9"
    ];

    networkmanager = {
      enable = true;
      unmanaged = ["*"];
    };
  };

  services.unbound.enable = true;
  system = {
    stateVersion = "24.11";
    preset = "wsl";
  };
  virtualisation.docker.enable = true;
}
