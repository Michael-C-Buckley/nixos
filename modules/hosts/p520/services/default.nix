{config, ...}: {
  flake.modules.nixos.p520 = {
    imports = with config.flake.modules.nixos; [
      hydra
    ];

    services.hydra.enable = true;
  };
}
