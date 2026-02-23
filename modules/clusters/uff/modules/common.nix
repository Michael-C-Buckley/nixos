{config, ...}: {
  flake.modules.nixos.uff = {
    imports = with config.flake.modules.nixos; [
      serverPreset
      systemd-boot
      impermanence
      systemd-credentials

      # Network
      secrets-nic-rename
      dnscrypt-proxy
      ntp
      wifi-home
      homelabPreset
    ];

    sops.defaultSopsFile = "/etc/secrets/clusters/uff/uff.yaml";
  };
}
