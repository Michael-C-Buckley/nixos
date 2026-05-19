{flake, ...}: {
  imports = with flake.nixosModules;
    [
      lanzaboote
      laptop-preset
      t14-secrets
      t14-wireguard
    ]
    ++ [
      ./hardware
      ./networking
      ./systemd/night-led.nix
      ./user/noctalia.nix
    ];

  security.tpm2.enable = true;
  system.stateVersion = "24.11";
}
