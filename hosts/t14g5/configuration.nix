{flake, ...}: {
  imports = with flake.nixosModules; [
    laptop-preset
    t14-secrets
    t14-wireguard
  ];

  sops.age = {
    keyFile = "/var/lib/nixos/tpm.keys";
    sshKeyPaths = [];
  };

  security.tpm2.enable = true;
  system.stateVersion = "26.05";
}
