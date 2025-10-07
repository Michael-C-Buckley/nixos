_: {
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

  services.k3s.enable = true;
}
