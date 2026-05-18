{flake, ...}: {
  imports = with flake.modules.nixos;
    [
      systemd-boot
      laptopPreset
      t14-secrets
      t14-wireguard
    ]
    ++ [
      ./hardware
      ./networking
    ];

  sops.age = {
    keyFile = "/var/lib/nixos/tpm.keys";
    sshKeyPaths = [];
  };

  security.tpm2.enable = true;
  system.stateVersion = "26.05";
}
