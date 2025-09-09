_: {
  imports = [
    ./hardware
    ./networking
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

  sops.secrets.cache-private.owner = "hydra";

  services = {
    hydra.enable = true;
    nix-serve = {
      enable = true;
      secretKeyFile = "/run/secrets/cache-private";
    };
  };
}
