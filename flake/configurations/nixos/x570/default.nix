{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  system = {
    builder.enable = true;
    preset = "desktop";
    stateVersion = "25.05";
    impermanence.enable = true;
    zfs.enable = true;
  };

  services = {
    flatpak.enable = true;
    unbound.enable = true;
    podman.enable = true;
  };

  security.tpm2.enable = true;

  virtualisation = {
    incus.enable = true;
    gns3.enable = true;
  };
}
