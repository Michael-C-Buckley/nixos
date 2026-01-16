{config, ...}: {
  flake.modules.nixos.sff3 = {
    imports = with config.flake.modules.nixos; [
      serverPreset
    ];

    networking = {
      hostName = "sff3";
      hostId = "baeee123";
    };

    system.stateVersion = "26.05";
  };
}
