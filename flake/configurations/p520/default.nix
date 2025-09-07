_: {
  imports = [
    ./hardware
    ./networking
    ./systemd
  ];

  virtualisation = {
    containerlab.enable = true;
    libvirtd.enable = true;
    podman.enable = true;
  };

  system = {
    impermanence.enable = true;
    preset = "server";
    stateVersion = "25.11";
    zfs.enable = true;
  };

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };
}
