_: {
  imports = [
    ./hardware
    ./networking
    ./systemd
  ];

  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
  };

  sops.age.sshKeyPaths = [];

  security.tpm2.enable = true;

  system = {
    impermanence.enable = true;
    boot.uuid = "D8CD-79D6";
    preset = "server";
    stateVersion = "24.05";
    zfs.enable = true;
  };
}
