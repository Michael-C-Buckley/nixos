_: {
  imports = [
    ../../modules/presets/nvidia.nix
    ./modules
    ./networking
  ];

  system.preset = "server";

  services.resolved.enable = false;
}
