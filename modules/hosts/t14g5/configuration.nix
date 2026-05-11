# T14g5 Laptop Configuration
{config, ...}: {
  flake.modules.nixos.t14g5 = {
    imports = with config.flake.modules.nixos; [
      # lanzaboote
      systemd-boot
      laptopPreset
      systemd-credentials
    ];

    security.tpm2.enable = true;
    system.stateVersion = "26.05";
  };
}
