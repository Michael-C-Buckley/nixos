# T14 Laptop Configuration
{config, ...}: {
  flake.modules.nixos.t14 = {
    imports = with config.flake.modules.nixos; [
      systemd-boot
      impermanence
      laptopPreset
      systemd-credentials
    ];

    security.tpm2.enable = true;
    system.stateVersion = "24.11";
  };
}
