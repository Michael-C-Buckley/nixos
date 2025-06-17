# T14 Laptop Configuration
{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.t14
    ./hardware
    ./networking
    ./systemd
    ./hyprland.nix
  ];

  virtualisation = {
    docker.enable = true;
    incus.enable = true;
  };

  security.tpm2.enable = true;

  sops.gnupg = {
    home = "/etc/sops";
    sshKeyPaths = [];
  };

  system = {
    preset = "laptop";
    stateVersion = "24.11";
    impermanence.enable = true;
    zfs = {
      enable = true;
      encryption = true;
    };
  };
}
