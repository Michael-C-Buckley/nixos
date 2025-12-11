# T14 Laptop Configuration
{config, ...}: {
  flake.modules.nixos.t14 = {
    imports = with config.flake.modules.nixos; [
      laptopPreset
      niri
    ];

    custom.tuigreet.defaultCommand = "niri-session";

    security.tpm2.enable = true;
    system.stateVersion = "24.11";
    nix.settings.substituters = ["http://p520:5000"];
  };
}
