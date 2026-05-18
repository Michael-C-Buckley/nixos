{flake, ...}: {
  imports = with flake.modules.nixos;
    [
      systemd-boot
      desktopPreset
      homelabPreset
      intelGraphics
      wifi
      gaming
      lab-network
    ]
    ++ [
      ./disko
      ./hardware
      ./networking
      ./secrets.nix
    ];

  system.stateVersion = "26.05";

  sops.age = {
    keyFile = "/var/lib/nixos/tpm.keys";
    sshKeyPaths = [];
  };
}
