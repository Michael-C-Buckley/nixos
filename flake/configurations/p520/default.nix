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

  services = {
    hydra = {
      enable = true;
      extraConfig = ''
        allow-import-from-derivation = true
      '';
    };
    nix-serve = {
      enable = true;
      secretKeyFile = "/run/secrets/cache-private";
    };
  };
}
