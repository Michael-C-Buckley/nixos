# T14 Laptop Configuration
{config, ...}: {
  flake.modules.nixos.t14 = {
    imports = with config.flake.modules.nixos; [
      laptopPreset
      resolved
    ];

    security.tpm2.enable = true;
    system.stateVersion = "24.11";
    nix.settings.trusted-substituters = ["http://192.168.48.5:5000"];
    virtualisation.podman.enable = true;

    # Decrease Ghostty transparency a bit
    hjem.users.michael.rum.programs.ghostty.settings.background-opacity = "0.7";
  };
}
