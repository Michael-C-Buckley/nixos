_: {
  imports = [
    ./containers
    ./hardware
    ./networking
    ./services
    ./systemd
    ./remote-builders.nix
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

  # Allows vscode remote connections to just work
  programs.nix-ld.enable = true;

  sops.secrets.cachePrivateKey.owner = "hydra";
}
