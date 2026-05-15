{config, ...}: {
  flake.modules.nixos.x570 = {
    imports = with config.flake.modules.nixos; [
      lanzaboote
      desktopPreset
      homelabPreset
      intelGraphics
      wifi
      gaming
      lab-network
      systemd-credentials
    ];

    system.stateVersion = "26.05";

    sops.age = {
      keyFile = "/var/lib/nixos/tpm.keys";
      sshKeyPaths = [];
    };
  };
}
