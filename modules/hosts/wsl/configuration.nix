{config, ...}: let
  inherit (config.flake.modules.nixos) linuxPreset;
  inherit (config.flake.hjemConfigs) nixos;
in {
  flake.modules.nixos.wsl = {
    imports = [
      linuxPreset
      nixos
    ];

    networking = {
      hostName = "wsl";
      hostId = "e07f0101";
      nameservers = [
        "1.1.1.1"
        "9.9.9.9"
      ];
      networkmanager = {
        enable = true;
        unmanaged = ["*"];
      };
    };

    system.stateVersion = "25.05";
  };
}
