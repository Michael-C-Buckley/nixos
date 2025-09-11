{
  imports = [
    ./wsl.nix
  ];

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
    impermanence.enable = false;
    preset = "wsl";
    stateVersion = "24.11";
  };
  virtualisation.docker.enable = true;
}
