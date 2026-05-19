{flake, ...}: {
  imports = with flake.nixosModules;
    [
      desktop-preset
      intelGraphics
      wifi-home
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
