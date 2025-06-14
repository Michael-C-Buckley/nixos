{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  system = {
    preset = "desktop";
    stateVersion = "25.05";
    impermanence.enable = true;
    zfs.enable = true;
  };

  services = {
    flatpak.enable = true;
    nix-serve.enable = true;
    k3s.enable = true;
    unbound.enable = true;
  };

  security.tpm2.enable = true;

  virtualisation = {
    docker.enable = true;
    incus.enable = true;
    libvirtd.enable = true;
    gns3.enable = true;
  };
}
