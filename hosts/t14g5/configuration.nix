{flake, ...}: {
  imports = with flake.nixosModules; [
    disko
    laptop-preset
    t14-secrets
    t14-wireguard
  ];

  security.tpm2.enable = true;
  system.stateVersion = "26.05";
}
