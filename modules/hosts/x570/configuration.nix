{config, ...}: {
  flake.modules.nixos.x570 = {
    imports = with config.flake.modules.nixos; [
      systemd-boot
      desktopPreset
      homelabPreset
      intelGraphics
      wifi
      gaming
      lab-network
    ];

    system.stateVersion = "26.05";

    sops.age = {
      keyFile = "/var/lib/nixos/tpm.keys";
      sshKeyPaths = [];
    };
  };
}
