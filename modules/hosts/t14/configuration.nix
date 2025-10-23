# T14 Laptop Configuration
{config, ...}: {
  flake.modules.nixos.t14 = {
    imports = with config.flake.modules.nixos; [
      laptopPreset
      unbound
    ];

    security.tpm2.enable = true;
    system.stateVersion = "24.11";
    nix.settings.trusted-substituters = ["http://192.168.48.5:5000"];
    virtualisation.podman.enable = true;
  };
}
