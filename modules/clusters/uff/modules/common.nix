{config, ...}: {
  flake.modules.nixos.uff = {
    imports = with config.flake.modules.nixos; [
      systemd-boot
      impermanence
      homelabPreset
      wifi-home
      systemd-credentials
      secrets-nic-rename
    ];

    sops.defaultSopsFile = "/etc/secrets/clusters/uff/uff.yaml";
  };
}
