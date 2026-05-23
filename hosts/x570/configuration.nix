{flake, ...}: {
  imports = with flake.nixosModules; [
    desktop-preset
    disko
    intelGraphics
    wifi-home
    gaming
    lab-network
  ];

  system.stateVersion = "26.05";

  sops.age = {
    keyFile = "/var/lib/nixos/tpm.keys";
    sshKeyPaths = [];
  };
}
